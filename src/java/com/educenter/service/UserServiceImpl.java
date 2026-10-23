package com.educenter.service;

import com.educenter.dto.ProfileUpdateDTO;
import com.educenter.dto.UserPageDTO;
import com.educenter.dto.UserViewDTO;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Role;
import com.educenter.entity.User;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.RoleRepository;
import com.educenter.repository.UserRepository;
import com.educenter.util.JPAUtil;
import com.educenter.util.ValidationUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Implementation of UserService managing profiles and administrative user mutations.
 */
public class UserServiceImpl implements UserService {

    private static final Logger LOGGER = Logger.getLogger(UserServiceImpl.class.getName());

    private static final Set<String> CANONICAL_ROLES = Set.of("ADMIN", "STAFF", "TEACHER", "STUDENT", "PARENT");

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final AuditLogRepository auditLogRepository;
    private final java.util.function.Supplier<EntityManager> entityManagerSupplier;

    public UserServiceImpl() {
        this(new UserRepository(), new RoleRepository(), new AuditLogRepository(), JPAUtil::getEntityManager);
    }

    public UserServiceImpl(UserRepository userRepository, RoleRepository roleRepository,
                           AuditLogRepository auditLogRepository) {
        this(userRepository, roleRepository, auditLogRepository, JPAUtil::getEntityManager);
    }

    public UserServiceImpl(UserRepository userRepository, RoleRepository roleRepository,
                           AuditLogRepository auditLogRepository,
                           java.util.function.Supplier<EntityManager> entityManagerSupplier) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.auditLogRepository = auditLogRepository;
        this.entityManagerSupplier = (entityManagerSupplier != null) ? entityManagerSupplier : JPAUtil::getEntityManager;
    }

    @Override
    public User updateProfile(Long userId, ProfileUpdateDTO dto) {
        if (userId == null) {
            throw new ValidationException("Mã người dùng không hợp lệ.");
        }
        if (dto == null) {
            throw new ValidationException("Dữ liệu cập nhật không hợp lệ.");
        }

        if (!ValidationUtil.isValidFullName(dto.getFullName())) {
            throw new ValidationException("Họ và tên không hợp lệ (từ 2 đến 150 ký tự).");
        }
        if (!ValidationUtil.isValidPhone(dto.getPhone(), false)) {
            throw new ValidationException("Số điện thoại không đúng định dạng Việt Nam.");
        }
        String normalizedAvatar = ValidationUtil.normalizeAvatarUrl(dto.getAvatarUrl());
        if (!ValidationUtil.isValidAvatarUrl(normalizedAvatar)) {
            throw new ValidationException("Đường dẫn ảnh đại diện không hợp lệ (tối đa 500 ký tự).");
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = userRepository.findByIdWithLock(em, userId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy thông tin tài khoản."));

            user.setFullName(dto.getFullName().trim());
            user.setPhone(dto.getPhone() != null && !dto.getPhone().trim().isEmpty() ? dto.getPhone().trim() : null);
            user.setAvatarUrl(normalizedAvatar);

            User updated = userRepository.update(em, user);
            tx.commit();
            LOGGER.info("Cập nhật hồ sơ thành công cho user ID: " + userId);
            return updated;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) {
                throw (ValidationException) e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật hồ sơ: " + e.getMessage(), e);
            throw new ValidationException("Không thể cập nhật hồ sơ. Vui lòng thử lại sau.");
        } finally {
            em.close();
        }
    }

    @Override
    public void toggleUserStatus(Long adminId, Long targetUserId, String newStatus, String ipAddress) {
        if (adminId == null || targetUserId == null) {
            throw new ValidationException("Thông tin định danh không hợp lệ.");
        }
        String statusUpper = (newStatus != null) ? newStatus.trim().toUpperCase() : "";
        if (!User.STATUS_ACTIVE.equals(statusUpper) && !User.STATUS_LOCKED.equals(statusUpper) && !User.STATUS_INACTIVE.equals(statusUpper)) {
            throw new ValidationException("Trạng thái người dùng không hợp lệ: " + newStatus);
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            roleRepository.lockAdminRole(em);

            // Verify admin rights
            User admin = userRepository.findById(em, adminId)
                    .orElseThrow(() -> new AuthorizationException("Tài khoản quản trị viên không tồn tại."));
            if (!admin.hasRole("ADMIN") || !admin.isActive()) {
                throw new AuthorizationException("Bạn không có quyền thực hiện thao tác quản trị này.");
            }

            // Lock and load target user
            User target = userRepository.findByIdWithLock(em, targetUserId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy người dùng cần thay đổi trạng thái."));

            String oldStatus = target.getStatus();
            if (oldStatus.equals(statusUpper)) {
                tx.commit();
                return; // Nothing to change
            }

            // Safety rules when locking/deactivating
            if (User.STATUS_LOCKED.equals(statusUpper) || User.STATUS_INACTIVE.equals(statusUpper)) {
                if (adminId.equals(targetUserId)) {
                    throw new ValidationException("Không thể tự vô hiệu hóa tài khoản quản trị viên đang đăng nhập.");
                }
                if (target.hasRole("ADMIN")) {
                    long activeAdmins = userRepository.countActiveAdmins(em);
                    if (activeAdmins <= 1) {
                        throw new ValidationException("Không thể khóa tài khoản quản trị viên tối cao cuối cùng.");
                    }
                }
            }

            target.setStatus(statusUpper);
            userRepository.update(em, target);

            // Record Audit Log (BR18)
            AuditLog auditLog = new AuditLog(
                    adminId,
                    "UPDATE_USER_STATUS",
                    "Users",
                    targetUserId,
                    "{\"status\":\"" + oldStatus + "\"}",
                    "{\"status\":\"" + statusUpper + "\"}",
                    ipAddress
            );
            auditLogRepository.save(em, auditLog);

            tx.commit();
            LOGGER.info("Admin " + adminId + " thay đổi trạng thái user " + targetUserId + ": " + oldStatus + " -> " + statusUpper);
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException || e instanceof AuthorizationException) {
                throw e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi đổi trạng thái người dùng: " + e.getMessage(), e);
            throw new ValidationException("Không thể thay đổi trạng thái tài khoản lúc này.");
        } finally {
            em.close();
        }
    }

    @Override
    public void assignRoles(Long adminId, Long targetUserId, Set<String> roleCodes, String ipAddress) {
        if (adminId == null || targetUserId == null) {
            throw new ValidationException("Thông tin định danh không hợp lệ.");
        }
        if (roleCodes == null || roleCodes.isEmpty()) {
            throw new ValidationException("Người dùng phải có ít nhất một vai trò.");
        }

        Set<String> cleanRoleCodes = roleCodes.stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .map(String::toUpperCase)
                .collect(Collectors.toSet());

        for (String code : cleanRoleCodes) {
            if (!CANONICAL_ROLES.contains(code)) {
                throw new ValidationException("Vai trò không hợp lệ: " + code);
            }
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            roleRepository.lockAdminRole(em);

            // Verify admin rights
            User admin = userRepository.findById(em, adminId)
                    .orElseThrow(() -> new AuthorizationException("Tài khoản quản trị viên không tồn tại."));
            if (!admin.hasRole("ADMIN") || !admin.isActive()) {
                throw new AuthorizationException("Bạn không có quyền phân vai trò người dùng.");
            }

            // Lock and load target user
            User target = userRepository.findByIdWithLock(em, targetUserId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy người dùng cần phân quyền."));

            Set<String> oldRoleCodes = target.getRoles().stream()
                    .map(Role::getCode)
                    .map(String::toUpperCase)
                    .collect(Collectors.toSet());

            // If demoting ADMIN
            if (oldRoleCodes.contains("ADMIN") && !cleanRoleCodes.contains("ADMIN")) {
                if (adminId.equals(targetUserId)) {
                    throw new ValidationException("Không thể tự gỡ bỏ quyền ADMIN của chính mình.");
                }
                long activeAdmins = userRepository.countActiveAdmins(em);
                if (activeAdmins <= 1) {
                    throw new ValidationException("Không thể tước quyền ADMIN của quản trị viên tối cao cuối cùng.");
                }
            }

            // Resolve new roles
            Set<Role> newRoles = new HashSet<>();
            for (String code : cleanRoleCodes) {
                Role r = roleRepository.findByCode(em, code)
                        .orElseThrow(() -> new ValidationException("Không tìm thấy vai trò: " + code));
                newRoles.add(r);
            }

            target.setRoles(newRoles);
            userRepository.update(em, target);

            // Record Audit Log (BR18)
            AuditLog auditLog = new AuditLog(
                    adminId,
                    "CHANGE_ROLE",
                    "Users",
                    targetUserId,
                    "{\"roles\":" + oldRoleCodes.toString() + "}",
                    "{\"roles\":" + cleanRoleCodes.toString() + "}",
                    ipAddress
            );
            auditLogRepository.save(em, auditLog);

            tx.commit();
            LOGGER.info("Admin " + adminId + " cập nhật vai trò cho user " + targetUserId + ": " + cleanRoleCodes);
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException || e instanceof AuthorizationException) {
                throw e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi phân quyền người dùng: " + e.getMessage(), e);
            throw new ValidationException("Không thể cập nhật vai trò người dùng lúc này.");
        } finally {
            em.close();
        }
    }

    @Override
    public UserPageDTO getUserList(String keyword, String roleCode, String status, int page, int pageSize) {
        int validPage = Math.max(1, page);
        int validSize = Math.max(1, Math.min(100, pageSize));
        int offset = (validPage - 1) * validSize;

        EntityManager em = entityManagerSupplier.get();
        try {
            List<User> users = userRepository.searchUsers(em, keyword, roleCode, status, offset, validSize);
            long totalRecords = userRepository.countUsers(em, keyword, roleCode, status);

            List<UserViewDTO> items = users.stream().map(u -> {
                List<String> rCodes = u.getRoles().stream().map(Role::getCode).sorted().collect(Collectors.toList());
                List<String> rNames = u.getRoles().stream().map(Role::getName).collect(Collectors.toList());
                return new UserViewDTO(
                        u.getId(),
                        u.getEmail(),
                        u.getFullName(),
                        u.getPhone(),
                        u.getAvatarUrl(),
                        u.getStatus(),
                        rCodes,
                        rNames,
                        u.getCreatedAt()
                );
            }).collect(Collectors.toList());

            UserPageDTO pageDTO = new UserPageDTO(items, totalRecords, validPage, validSize, keyword, roleCode, status);
            pageDTO.setAvailableRoles(roleRepository.findAll(em).stream()
                    .filter(role -> CANONICAL_ROLES.contains(role.getCode()))
                    .map(role -> new com.educenter.dto.RoleOptionDTO(role.getCode(), role.getName())).toList());
            pageDTO.setTotalActive(userRepository.countByStatus(em, User.STATUS_ACTIVE));
            pageDTO.setTotalLocked(userRepository.countByStatus(em, User.STATUS_LOCKED));
            return pageDTO;
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<UserViewDTO> getUserById(Long id) {
        if (id == null) {
            return Optional.empty();
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            return userRepository.findById(em, id).map(u -> {
                List<String> rCodes = u.getRoles().stream().map(Role::getCode).sorted().collect(Collectors.toList());
                List<String> rNames = u.getRoles().stream().map(Role::getName).collect(Collectors.toList());
                return new UserViewDTO(
                        u.getId(),
                        u.getEmail(),
                        u.getFullName(),
                        u.getPhone(),
                        u.getAvatarUrl(),
                        u.getStatus(),
                        rCodes,
                        rNames,
                        u.getCreatedAt()
                );
            });
        } finally {
            em.close();
        }
    }
}
