package com.educenter.service;

import com.educenter.dto.RegisterRequestDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Guardian;
import com.educenter.entity.PasswordResetToken;
import com.educenter.entity.Role;
import com.educenter.entity.Student;
import com.educenter.entity.StudentGuardian;
import com.educenter.entity.User;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.GuardianRepository;
import com.educenter.repository.PasswordResetRepository;
import com.educenter.repository.RoleRepository;
import com.educenter.repository.StudentRepository;
import com.educenter.repository.UserRepository;
import com.educenter.util.JPAUtil;
import com.educenter.util.PasswordUtil;
import com.educenter.util.ValidationUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.HexFormat;
import java.util.Optional;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Implementation of AuthService managing authentication and credential lifecycle.
 */
public class AuthServiceImpl implements AuthService {

    private static final Logger LOGGER = Logger.getLogger(AuthServiceImpl.class.getName());
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordResetRepository passwordResetRepository;
    private final StudentRepository studentRepository;
    private final GuardianRepository guardianRepository;
    private final AuditLogRepository auditLogRepository;
    private final java.util.function.Supplier<EntityManager> entityManagerSupplier;

    public AuthServiceImpl() {
        this(new UserRepository(), new RoleRepository(), new PasswordResetRepository(),
             new StudentRepository(), new GuardianRepository(), new AuditLogRepository(),
             JPAUtil::getEntityManager);
    }

    public AuthServiceImpl(UserRepository userRepository, RoleRepository roleRepository,
                           PasswordResetRepository passwordResetRepository) {
        this(userRepository, roleRepository, passwordResetRepository,
             new StudentRepository(), new GuardianRepository(), new AuditLogRepository(),
             JPAUtil::getEntityManager);
    }

    public AuthServiceImpl(UserRepository userRepository, RoleRepository roleRepository,
                           PasswordResetRepository passwordResetRepository,
                           java.util.function.Supplier<EntityManager> entityManagerSupplier) {
        this(userRepository, roleRepository, passwordResetRepository,
             new StudentRepository(), new GuardianRepository(), new AuditLogRepository(),
             entityManagerSupplier);
    }

    public AuthServiceImpl(UserRepository userRepository, RoleRepository roleRepository,
                           PasswordResetRepository passwordResetRepository,
                           StudentRepository studentRepository,
                           GuardianRepository guardianRepository,
                           AuditLogRepository auditLogRepository,
                           java.util.function.Supplier<EntityManager> entityManagerSupplier) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordResetRepository = passwordResetRepository;
        this.studentRepository = (studentRepository != null) ? studentRepository : new StudentRepository();
        this.guardianRepository = (guardianRepository != null) ? guardianRepository : new GuardianRepository();
        this.auditLogRepository = (auditLogRepository != null) ? auditLogRepository : new AuditLogRepository();
        this.entityManagerSupplier = (entityManagerSupplier != null) ? entityManagerSupplier : JPAUtil::getEntityManager;
    }

    @Override
    public UserPrincipalDTO login(String email, String password) {
        String normalizedEmail = ValidationUtil.normalizeEmail(email);
        if (normalizedEmail == null || normalizedEmail.isEmpty() || password == null || password.isEmpty()) {
            throw new ValidationException("Vui lòng nhập đầy đủ email và mật khẩu.");
        }

        EntityManager em = entityManagerSupplier.get();
        try {
            Optional<User> userOpt = userRepository.findByEmail(em, normalizedEmail);
            if (userOpt.isEmpty()) {
                throw new ValidationException("Email hoặc mật khẩu không chính xác.");
            }

            User user = userOpt.get();
            if (!PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
                throw new ValidationException("Email hoặc mật khẩu không chính xác.");
            }

            if (user.isLocked()) {
                throw new ValidationException("Tài khoản của bạn đã bị tạm khóa. Vui lòng liên hệ ban quản trị để được hỗ trợ.");
            }

            if (!user.isActive()) {
                throw new ValidationException("Tài khoản của bạn chưa được kích hoạt hoặc đã ngừng hoạt động.");
            }

            return mapToPrincipal(user);
        } finally {
            em.close();
        }
    }

    @Override
    public User register(RegisterRequestDTO dto) {
        if (dto == null) {
            throw new ValidationException("Dữ liệu đăng ký không hợp lệ.");
        }

        // 1. Validate Full Name
        if (!ValidationUtil.isValidFullName(dto.getFullName())) {
            throw new ValidationException("Họ và tên không hợp lệ (yêu cầu từ 2 đến 150 ký tự).");
        }

        // 2. Validate & Normalize Email (BR01)
        String normalizedEmail = ValidationUtil.normalizeEmail(dto.getEmail());
        if (!ValidationUtil.isValidEmail(normalizedEmail)) {
            throw new ValidationException("Địa chỉ email không đúng định dạng.");
        }

        // 3. Validate Phone (optional)
        if (!ValidationUtil.isValidPhone(dto.getPhone(), false)) {
            throw new ValidationException("Số điện thoại không đúng định dạng Việt Nam (10 chữ số).");
        }

        // 4. Validate Role Code (STUDENT or PARENT only)
        String roleCode = (dto.getRoleCode() != null) ? dto.getRoleCode().trim().toUpperCase() : "STUDENT";
        if (!"STUDENT".equals(roleCode) && !"PARENT".equals(roleCode)) {
            throw new ValidationException("Chỉ cho phép đăng ký tài khoản Học viên (STUDENT) hoặc Phụ huynh (PARENT).");
        }

        // 4b. Validate Student Email for PARENT registration (FR-001 / D18)
        String studentEmail = ValidationUtil.normalizeEmail(dto.getStudentEmail());
        if ("PARENT".equals(roleCode)) {
            if (studentEmail == null || studentEmail.isEmpty()) {
                throw new ValidationException("Phụ huynh vui lòng cung cấp địa chỉ email của học sinh (con) để hệ thống tự động liên kết.");
            }
            if (!ValidationUtil.isValidEmail(studentEmail)) {
                throw new ValidationException("Địa chỉ email của học sinh (con) không đúng định dạng.");
            }
            if (normalizedEmail.equalsIgnoreCase(studentEmail)) {
                throw new ValidationException("Email của phụ huynh không được trùng với email của học sinh (con).");
            }
        }

        // 5. Validate Password & Confirmation
        if (!ValidationUtil.isValidPassword(dto.getPassword())) {
            throw new ValidationException("Mật khẩu phải có độ dài từ 6 ký tự trở lên (tối đa 72 bytes).");
        }
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new ValidationException("Mật khẩu xác nhận không khớp.");
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            // Check email uniqueness (BR01)
            if (userRepository.existsByEmail(em, normalizedEmail)) {
                throw new ValidationException("Địa chỉ email này đã được đăng ký trong hệ thống.");
            }

            // Find role
            Role role = roleRepository.findByCode(em, roleCode)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy vai trò hệ thống: " + roleCode));

            // Verify student exists when parent registers
            Student studentTarget = null;
            if ("PARENT".equals(roleCode)) {
                Optional<Student> studentOpt = studentRepository.findByEmail(em, studentEmail);
                if (studentOpt.isEmpty()) {
                    throw new ValidationException("Không tìm thấy học sinh với email: " + studentEmail + " trong hệ thống. Vui lòng kiểm tra lại email của con hoặc liên hệ trung tâm.");
                }
                studentTarget = studentOpt.get();
            }

            // Hash password with BCrypt (SEC-01)
            String hashedPassword = PasswordUtil.hashPassword(dto.getPassword());

            // Create user
            User user = new User(normalizedEmail, hashedPassword, dto.getFullName().trim(),
                    dto.getPhone() != null ? dto.getPhone().trim() : null);
            user.setStatus(User.STATUS_ACTIVE);
            user.addRole(role);

            userRepository.save(em, user);

            // If PARENT: create or ensure Guardian profile and auto-link StudentGuardian (D18)
            if ("PARENT".equals(roleCode) && studentTarget != null) {
                Guardian guardian = guardianRepository.findByUserId(em, user.getId()).orElseGet(Guardian::new);
                guardian.setUser(user);
                guardian.setFullName(user.getFullName());
                guardian.setPhone(user.getPhone() != null ? user.getPhone() : "");
                guardian.setEmail(user.getEmail());
                guardian.setStatus("ACTIVE");
                guardianRepository.save(em, guardian);

                Optional<StudentGuardian> existingLinkOpt = guardianRepository.findLinkByStudentAndGuardian(em, studentTarget.getId(), guardian.getId());
                if (existingLinkOpt.isEmpty()) {
                    StudentGuardian link = new StudentGuardian();
                    link.setStudent(studentTarget);
                    link.setGuardian(guardian);
                    link.setRelationship("Phụ huynh");
                    boolean hasPrimary = studentRepository.countGuardiansByStudentId(em, studentTarget.getId()) > 0;
                    link.setIsPrimary(!hasPrimary);
                    link.setVerifiedAt(LocalDateTime.now());
                    link.setVerifiedBy(user.getId());
                    guardianRepository.saveLink(em, link);
                } else {
                    StudentGuardian link = existingLinkOpt.get();
                    if (link.getVerifiedAt() == null) {
                        link.setVerifiedAt(LocalDateTime.now());
                        link.setVerifiedBy(user.getId());
                        guardianRepository.saveLink(em, link);
                    }
                }

                AuditLog auditLog = new AuditLog(user.getId(), "AUTO_LINK_GUARDIAN", "StudentGuardians", studentTarget.getId(),
                        null, "Tự động liên kết và xác minh phụ huynh " + user.getEmail() + " với học sinh " + studentTarget.getFullName() + " (" + studentEmail + ")", null);
                auditLogRepository.save(em, auditLog);
            } else if ("STUDENT".equals(roleCode)) {
                // Auto link user to existing Student profile with matching email and null user
                Optional<Student> studentOpt = studentRepository.findByEmail(em, normalizedEmail);
                if (studentOpt.isPresent() && studentOpt.get().getUser() == null) {
                    Student student = studentOpt.get();
                    student.setUser(user);
                    studentRepository.update(em, student);

                    AuditLog auditLog = new AuditLog(user.getId(), "AUTO_LINK_STUDENT_USER", "Students", student.getId(),
                            null, "Tự động gắn tài khoản User (" + user.getEmail() + ") vào hồ sơ học sinh " + student.getFullName(), null);
                    auditLogRepository.save(em, auditLog);
                }
            }

            tx.commit();
            LOGGER.info("Đăng ký thành công tài khoản mới: " + normalizedEmail + " với vai trò " + roleCode);
            return user;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) {
                throw (ValidationException) e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi đăng ký tài khoản: " + e.getMessage(), e);
            throw new ValidationException("Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại sau.");
        } finally {
            em.close();
        }
    }

    @Override
    public void changePassword(Long userId, String currentPassword, String newPassword, String confirmNewPassword) {
        if (userId == null) {
            throw new ValidationException("Mã người dùng không hợp lệ.");
        }
        if (currentPassword == null || currentPassword.isEmpty()) {
            throw new ValidationException("Vui lòng nhập mật khẩu hiện tại.");
        }
        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new ValidationException("Mật khẩu mới phải có ít nhất 6 ký tự (tối đa 72 bytes).");
        }
        if (currentPassword.equals(newPassword)) {
            throw new ValidationException("Mật khẩu mới không được trùng với mật khẩu hiện tại.");
        }
        if (!newPassword.equals(confirmNewPassword)) {
            throw new ValidationException("Mật khẩu xác nhận không khớp.");
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = userRepository.findByIdWithLock(em, userId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy thông tin tài khoản."));

            if (!PasswordUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
                throw new ValidationException("Mật khẩu hiện tại không đúng.");
            }

            String newHashedPassword = PasswordUtil.hashPassword(newPassword);
            user.setPasswordHash(newHashedPassword);
            userRepository.update(em, user);

            tx.commit();
            LOGGER.info("Đổi mật khẩu thành công cho user ID: " + userId);
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) {
                throw (ValidationException) e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi đổi mật khẩu: " + e.getMessage(), e);
            throw new ValidationException("Không thể cập nhật mật khẩu. Vui lòng thử lại sau.");
        } finally {
            em.close();
        }
    }

    @Override
    public String requestPasswordReset(String email) {
        String normalizedEmail = ValidationUtil.normalizeEmail(email);
        if (!ValidationUtil.isValidEmail(normalizedEmail)) {
            throw new ValidationException("Vui lòng nhập địa chỉ email hợp lệ.");
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Optional<User> userOpt = userRepository.findByEmail(em, normalizedEmail);
            if (userOpt.isEmpty()) {
                tx.commit();
                throw new ValidationException("Không tìm thấy tài khoản nào liên kết với email '" + normalizedEmail + "'. Vui lòng kiểm tra lại địa chỉ email của bạn!");
            }

            User user = userRepository.findByIdWithLock(em, userOpt.get().getId()).orElseThrow();
            if (!user.isActive()) {
                tx.commit();
                throw new ValidationException("Tài khoản liên kết với email này hiện đang bị khóa hoặc ngưng hoạt động. Vui lòng liên hệ ban quản trị trung tâm!");
            }

            // Invalidate any unconsumed tokens for this user
            passwordResetRepository.invalidatePriorTokens(em, user.getId());

            // Generate 32-byte secure random raw token
            byte[] tokenBytes = new byte[32];
            SECURE_RANDOM.nextBytes(tokenBytes);
            String rawToken = HexFormat.of().formatHex(tokenBytes);

            // Compute SHA-256 hash to store in DB
            String tokenHash = hashToken(rawToken);

            LocalDateTime expiresAt = LocalDateTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).plusMinutes(30);
            PasswordResetToken resetToken = new PasswordResetToken(user, tokenHash, expiresAt);
            passwordResetRepository.save(em, resetToken);

            tx.commit();
            LOGGER.info("Sinh token đặt lại mật khẩu cho user: " + normalizedEmail);
            return rawToken;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) {
                throw (ValidationException) e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi yêu cầu đặt lại mật khẩu: " + e.getMessage(), e);
            throw new ValidationException("Không thể gửi yêu cầu đặt lại mật khẩu lúc này.");
        } finally {
            em.close();
        }
    }

    @Override
    public void resetPassword(String rawToken, String newPassword, String confirmNewPassword) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            throw new ValidationException("Mã token đặt lại mật khẩu không hợp lệ.");
        }
        if (!ValidationUtil.isValidPassword(newPassword)) {
            throw new ValidationException("Mật khẩu mới phải có ít nhất 6 ký tự (tối đa 72 bytes).");
        }
        if (!newPassword.equals(confirmNewPassword)) {
            throw new ValidationException("Mật khẩu xác nhận không khớp.");
        }

        String tokenHash = hashToken(rawToken.trim());

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Optional<PasswordResetToken> tokenOpt = passwordResetRepository.findByTokenHash(em, tokenHash);
            if (tokenOpt.isEmpty()) {
                throw new ValidationException("Liên kết đặt lại mật khẩu không hợp lệ hoặc không tồn tại.");
            }

            userRepository.findByIdWithLock(em, tokenOpt.get().getUser().getId()).orElseThrow();
            PasswordResetToken resetToken = passwordResetRepository.findByTokenHashForUpdate(em, tokenHash)
                    .orElseThrow(() -> new ValidationException("Liên kết đã hết hiệu lực."));
            if (!resetToken.isValid()) {
                throw new ValidationException("Liên kết đặt lại mật khẩu đã hết hạn hoặc đã được sử dụng.");
            }

            User user = resetToken.getUser();
            if (user.isLocked()) {
                throw new ValidationException("Tài khoản của bạn đang bị khóa, không thể đặt lại mật khẩu.");
            }

            // Update user password
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            user.setPasswordHash(hashedPassword);
            userRepository.update(em, user);

            // Mark token consumed
            resetToken.setConsumedAt(LocalDateTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh")));

            tx.commit();
            LOGGER.info("Đặt lại mật khẩu thành công cho user: " + user.getEmail());
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) {
                throw (ValidationException) e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi đặt lại mật khẩu: " + e.getMessage(), e);
            throw new ValidationException("Không thể hoàn tất đặt lại mật khẩu. Vui lòng thử lại.");
        } finally {
            em.close();
        }
    }

    @Override
    public UserPrincipalDTO refreshPrincipal(Long userId) {
        if (userId == null) {
            return null;
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            Optional<User> userOpt = userRepository.findById(em, userId);
            return userOpt.map(this::mapToPrincipal).orElse(null);
        } finally {
            em.close();
        }
    }

    private UserPrincipalDTO mapToPrincipal(User user) {
        Set<String> roleCodes = user.getRoles().stream()
                .map(Role::getCode)
                .map(String::toUpperCase)
                .collect(Collectors.toSet());

        UserPrincipalDTO principal = new UserPrincipalDTO(
                user.getId(),
                user.getEmail(),
                user.getFullName(),
                user.getPhone(),
                user.getAvatarUrl(),
                user.getStatus(),
                roleCodes
        );
        principal.setCredentialFingerprint(hashToken(user.getPasswordHash()));
        return principal;
    }

    @Override
    public com.educenter.dto.PasswordResetStateDTO inspectPasswordReset(String rawToken) {
        if (rawToken == null || !rawToken.matches("[a-fA-F0-9]{64}")) return new com.educenter.dto.PasswordResetStateDTO(false, 0);
        EntityManager em = entityManagerSupplier.get();
        try {
            Optional<PasswordResetToken> found = passwordResetRepository.findByTokenHash(em, hashToken(rawToken));
            if (found.isEmpty() || !found.get().isValid() || !found.get().getUser().isActive())
                return new com.educenter.dto.PasswordResetStateDTO(false, 0);
            long seconds = java.time.Duration.between(LocalDateTime.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh")), found.get().getExpiresAt()).getSeconds();
            return new com.educenter.dto.PasswordResetStateDTO(seconds > 0, Math.max(0, seconds));
        } finally { em.close(); }
    }

    private String hashToken(String rawToken) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(rawToken.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 algorithm not available", e);
        }
    }
}
