package com.educenter.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/** Preserve historical database/markup image URLs while storing one copy of each image. */
@WebServlet(name = "LegacyImageServlet", urlPatterns = {
        "/assets/images/courses/classroom-hero.jpg", "/assets/images/teachers/teacher-nam.jpg"
})
public class LegacyImageServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String target = request.getServletPath().endsWith("classroom-hero.jpg")
                ? "/assets/images/courses/classroom.jpg" : "/assets/images/teachers/teacher-hung.jpg";
        response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
        response.setHeader("Location", request.getContextPath() + target);
        response.setHeader("Cache-Control", "public, max-age=86400");
    }
}
