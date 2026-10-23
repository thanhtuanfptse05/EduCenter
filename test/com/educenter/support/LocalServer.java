package com.educenter.support;

import java.io.File;
import java.nio.file.Files;
import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

/** Local Tomcat/Jasper runner; never changes the installed Windows service. */
public final class LocalServer implements AutoCloseable {
    private final Tomcat tomcat;

    public LocalServer(int port) throws Exception {
        this(port, false);
    }

    public LocalServer(int port, boolean failureRoute) throws Exception {
        tomcat = new Tomcat();
        tomcat.setBaseDir(Files.createTempDirectory("educenter-tomcat-").toString());
        tomcat.setPort(port);
        tomcat.getConnector().setProperty("address", "127.0.0.1");
        Context context = tomcat.addWebapp("/EduCenter", new File("web").getAbsolutePath());
        if (failureRoute) {
            Tomcat.addServlet(context, "VerificationFailure", new jakarta.servlet.http.HttpServlet() {
                @Override protected void doGet(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpServletResponse resp)
                        throws jakarta.servlet.ServletException {
                    throw new jakarta.servlet.ServletException("PRIVATE_VERIFICATION_SENTINEL");
                }
            });
            context.addServletMappingDecoded("/__verification/error", "VerificationFailure");
        }
        context.setParentClassLoader(LocalServer.class.getClassLoader());
        org.apache.catalina.loader.WebappLoader loader = new org.apache.catalina.loader.WebappLoader();
        loader.setDelegate(true);
        context.setLoader(loader);
        StandardRoot resources = new StandardRoot(context);
        resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                new File("build/repair/classes").getAbsolutePath(), "/"));
        context.setResources(resources);
        context.setReloadable(false);
        tomcat.start();
    }

    public String baseUrl() {
        return "http://127.0.0.1:" + tomcat.getConnector().getLocalPort() + "/EduCenter";
    }

    @Override
    public void close() throws Exception {
        tomcat.stop();
        tomcat.destroy();
    }

    public static void main(String[] args) throws Exception {
        SqlServerFixture fixture = Boolean.getBoolean("educenter.fixture") ? new SqlServerFixture() : null;
        LocalServer server = new LocalServer(Integer.getInteger("educenter.port", 18080));
        java.util.concurrent.atomic.AtomicBoolean closed = new java.util.concurrent.atomic.AtomicBoolean();
        Runnable cleanup = () -> {
            if (closed.compareAndSet(false, true)) {
                try { server.close(); } catch (Exception ignored) { }
                finally { if (fixture != null) fixture.close(); }
            }
        };
        Runtime.getRuntime().addShutdownHook(new Thread(cleanup));
        System.out.println("EduCenter local verification: " + server.baseUrl());
        if (fixture != null) {
            // Ant may terminate a forked JVM before shutdown hooks run on Windows.
            // A workspace stop marker provides deterministic SQL fixture cleanup.
            java.nio.file.Path marker = java.nio.file.Path.of("build/repair/stop-fixture-" + Integer.getInteger("educenter.port", 18080));
            Files.deleteIfExists(marker);
            while (!Files.exists(marker)) Thread.sleep(250);
            cleanup.run(); Files.deleteIfExists(marker); return;
        }
        server.tomcat.getServer().await();
    }
}
