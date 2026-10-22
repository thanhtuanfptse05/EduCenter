package com.educenter.service;

import com.educenter.dto.CartItemDTO;
import com.educenter.dto.CartViewDTO;
import com.educenter.dto.RegistrationCheckoutDTO;
import com.educenter.entity.Course;
import com.educenter.entity.Lead;
import com.educenter.entity.RegistrationCartItem;
import com.educenter.entity.User;
import com.educenter.service.ValidationException;
import com.educenter.repository.CourseRepository;
import com.educenter.repository.LeadRepository;
import com.educenter.repository.RegistrationCartRepository;
import com.educenter.repository.UserRepository;
import com.educenter.util.JPAUtil;
import com.educenter.util.ValidationUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;

public class CartServiceImpl implements CartService {

    public static final String SESSION_CART_KEY = "REGISTRATION_CART";

    private final CourseRepository courseRepository;
    private final RegistrationCartRepository cartRepository;
    private final UserRepository userRepository;
    private final LeadRepository leadRepository;
    private final Supplier<EntityManager> emSupplier;

    public CartServiceImpl() {
        this(new CourseRepository(), new RegistrationCartRepository(), new UserRepository(), new LeadRepository(), JPAUtil::getEntityManager);
    }

    public CartServiceImpl(CourseRepository courseRepository,
                           RegistrationCartRepository cartRepository,
                           UserRepository userRepository,
                           LeadRepository leadRepository,
                           Supplier<EntityManager> emSupplier) {
        this.courseRepository = courseRepository;
        this.cartRepository = cartRepository;
        this.userRepository = userRepository;
        this.leadRepository = leadRepository;
        this.emSupplier = emSupplier;
    }

    @Override
    public CartViewDTO getCart(HttpSession session, Long userId) {
        List<CartItemDTO> sessionItems = getSessionCartList(session);

        if (userId != null) {
            EntityManager em = emSupplier.get();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                // 1. If session has items (guest added before login), migrate them to DB
                if (!sessionItems.isEmpty()) {
                    Optional<User> userOpt = userRepository.findById(em, userId);
                    if (userOpt.isPresent()) {
                        User user = userOpt.get();
                        for (CartItemDTO sItem : sessionItems) {
                            Optional<RegistrationCartItem> existing = cartRepository.findByUserAndCourse(em, userId, sItem.getCourseId());
                            if (existing.isEmpty()) {
                                Optional<Course> cOpt = courseRepository.findById(em, sItem.getCourseId());
                                if (cOpt.isPresent()) {
                                    RegistrationCartItem dbItem = new RegistrationCartItem(user, cOpt.get(), sItem.getNotes());
                                    cartRepository.save(em, dbItem);
                                }
                            }
                        }
                    }
                    sessionItems.clear();
                    if (session != null) {
                        session.removeAttribute(SESSION_CART_KEY);
                    }
                }

                // 2. Load all DB items for user
                List<RegistrationCartItem> dbItems = cartRepository.findByUserId(em, userId);
                List<CartItemDTO> mapped = new ArrayList<>();
                for (RegistrationCartItem rci : dbItems) {
                    mapped.add(mapToDTO(rci.getCourse(), rci.getNotes()));
                }
                tx.commit();

                CartViewDTO view = new CartViewDTO();
                view.setItems(mapped);
                return view;
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                throw e;
            } finally {
                if (em != null && em.isOpen()) em.close();
            }
        }

        CartViewDTO view = new CartViewDTO();
        view.setItems(sessionItems);
        return view;
    }

    @Override
    public void addToCart(HttpSession session, Long userId, Long courseId, String notes) {
        if (courseId == null) {
            throw new ValidationException("Vui lòng chọn khóa học hợp lệ.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            Course course = courseRepository.findById(em, courseId)
                    .orElseThrow(() -> new ValidationException("Khóa học không tồn tại hoặc đã ngừng tuyển sinh."));

            if (!"OPEN".equalsIgnoreCase(course.getStatus())) {
                throw new ValidationException("Khóa học hiện không mở đăng ký tuyển sinh.");
            }

            if (userId != null) {
                tx.begin();
                User user = userRepository.findById(em, userId)
                        .orElseThrow(() -> new ValidationException("Tài khoản người dùng không hợp lệ."));

                Optional<RegistrationCartItem> existing = cartRepository.findByUserAndCourse(em, userId, courseId);
                if (existing.isPresent()) {
                    RegistrationCartItem item = existing.get();
                    if (notes != null && !notes.trim().isEmpty()) {
                        item.setNotes(notes.trim());
                        cartRepository.save(em, item);
                    }
                } else {
                    RegistrationCartItem newItem = new RegistrationCartItem(user, course, notes);
                    cartRepository.save(em, newItem);
                }
                tx.commit();
            } else {
                List<CartItemDTO> list = getSessionCartList(session);
                boolean exists = false;
                for (CartItemDTO it : list) {
                    if (it.getCourseId().equals(courseId)) {
                        exists = true;
                        if (notes != null && !notes.trim().isEmpty()) {
                            it.setNotes(notes.trim());
                        }
                        break;
                    }
                }
                if (!exists) {
                    list.add(mapToDTO(course, notes));
                }
                if (session != null) {
                    session.setAttribute(SESSION_CART_KEY, list);
                }
            }
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }

    @Override
    public void removeFromCart(HttpSession session, Long userId, Long courseId) {
        if (courseId == null) {
            return;
        }

        if (userId != null) {
            EntityManager em = emSupplier.get();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                cartRepository.deleteByUserAndCourse(em, userId, courseId);
                tx.commit();
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                throw e;
            } finally {
                if (em != null && em.isOpen()) em.close();
            }
        }

        List<CartItemDTO> list = getSessionCartList(session);
        list.removeIf(it -> courseId.equals(it.getCourseId()));
        if (session != null) {
            session.setAttribute(SESSION_CART_KEY, list);
        }
    }

    @Override
    public void clearCart(HttpSession session, Long userId) {
        if (userId != null) {
            EntityManager em = emSupplier.get();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();
                cartRepository.clearByUserId(em, userId);
                tx.commit();
            } catch (Exception e) {
                if (tx.isActive()) tx.rollback();
                throw e;
            } finally {
                if (em != null && em.isOpen()) em.close();
            }
        }

        if (session != null) {
            session.removeAttribute(SESSION_CART_KEY);
        }
    }

    @Override
    public String confirmRegistration(HttpSession session, Long userId, RegistrationCheckoutDTO checkoutDTO) {
        if (checkoutDTO == null) {
            throw new ValidationException("Dữ liệu thông tin đăng ký không hợp lệ.");
        }
        if (!ValidationUtil.isValidFullName(checkoutDTO.getFullName())) {
            throw new ValidationException("Họ và tên học sinh / người đăng ký phải từ 2 đến 150 ký tự.");
        }
        if (!ValidationUtil.isValidPhone(checkoutDTO.getPhoneNumber(), true)) {
            throw new ValidationException("Số điện thoại liên hệ không đúng định dạng di động Việt Nam (10 chữ số).");
        }
        if (checkoutDTO.getEmail() != null && !checkoutDTO.getEmail().trim().isEmpty() && !ValidationUtil.isValidEmail(checkoutDTO.getEmail())) {
            throw new ValidationException("Email không đúng định dạng tiêu chuẩn.");
        }
        if (checkoutDTO.getGradeLevel() == null || checkoutDTO.getGradeLevel() < 6 || checkoutDTO.getGradeLevel() > 12) {
            throw new ValidationException("Khối lớp đăng ký phải từ lớp 6 đến lớp 12.");
        }
        if (!checkoutDTO.isConsentChecked()) {
            throw new ValidationException("Vui lòng đồng ý với điều khoản nhận thông báo lịch thi và tư vấn xếp lớp để tiếp tục.");
        }

        // Check cart contents
        CartViewDTO currentCart = getCart(session, userId);
        if (currentCart.isEmpty()) {
            throw new ValidationException("Danh sách khóa học đăng ký đang trống. Vui lòng chọn ít nhất 1 khóa học.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Lead lead = new Lead();
            lead.setName(checkoutDTO.getFullName().trim());
            lead.setPhone(checkoutDTO.getPhoneNumber().trim().replaceAll("[\\s.-]", ""));
            lead.setEmail(checkoutDTO.getEmail() != null ? ValidationUtil.normalizeEmail(checkoutDTO.getEmail()) : null);
            lead.setGradeLevel(checkoutDTO.getGradeLevel());
            lead.setSource("WEBSITE");
            lead.setStatus("NEW");

            // Build rich notes
            StringBuilder notes = new StringBuilder();
            notes.append("ĐĂNG KÝ KHÓA HỌC TRỰC TUYẾN\n");
            if (checkoutDTO.getSchoolName() != null && !checkoutDTO.getSchoolName().trim().isEmpty()) {
                notes.append("• Trường đang học: ").append(checkoutDTO.getSchoolName().trim()).append("\n");
            }
            if (checkoutDTO.getTargetGoals() != null && !checkoutDTO.getTargetGoals().isEmpty()) {
                notes.append("• Mục tiêu kỳ thi: ").append(String.join(", ", checkoutDTO.getTargetGoals())).append("\n");
            }
            if (checkoutDTO.getNotes() != null && !checkoutDTO.getNotes().trim().isEmpty()) {
                notes.append("• Ghi chú học vụ: ").append(checkoutDTO.getNotes().trim()).append("\n");
            }
            notes.append("• Danh sách khóa học (").append(currentCart.getTotalCourses()).append(" khóa):\n");
            for (CartItemDTO it : currentCart.getItems()) {
                notes.append("  + [").append(it.getCourseCode()).append("] ").append(it.getCourseName())
                     .append(" - ").append(it.getFormattedFee()).append("\n");
            }
            notes.append("• Tổng học phí dự kiến: ").append(currentCart.getFormattedFinalFee());
            if (currentCart.getDiscount().compareTo(java.math.BigDecimal.ZERO) > 0) {
                notes.append(" (Đã trừ combo: ").append(currentCart.getFormattedDiscount()).append(")");
            }

            lead.setNotes(notes.toString());
            lead.setCreatedAt(LocalDateTime.now());
            lead.setUpdatedAt(LocalDateTime.now());

            lead = leadRepository.save(em, lead);

            // Clear cart
            if (userId != null) {
                cartRepository.clearByUserId(em, userId);
            }
            if (session != null) {
                session.removeAttribute(SESSION_CART_KEY);
            }

            tx.commit();

            int year = LocalDate.now().getYear();
            return "LEAD-" + year + "-" + String.format("%03d", lead.getId());
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            if (em != null && em.isOpen()) em.close();
        }
    }

    @SuppressWarnings("unchecked")
    private List<CartItemDTO> getSessionCartList(HttpSession session) {
        if (session == null) {
            return new ArrayList<>();
        }
        Object obj = session.getAttribute(SESSION_CART_KEY);
        if (obj instanceof List<?>) {
            return (List<CartItemDTO>) obj;
        }
        List<CartItemDTO> newList = new ArrayList<>();
        session.setAttribute(SESSION_CART_KEY, newList);
        return newList;
    }

    private CartItemDTO mapToDTO(Course c, String notes) {
        CartItemDTO dto = new CartItemDTO();
        dto.setCourseId(c.getId());
        dto.setCourseCode(c.getCode());
        dto.setCourseName(c.getName());
        dto.setGradeLevel(c.getGradeLevel());
        dto.setFee(c.getFee());
        dto.setTotalSessions(c.getTotalSessions());
        dto.setMaxCapacity(c.getMaxCapacity());
        dto.setImageUrl(c.getImageUrl());
        dto.setNotes(notes);

        if (c.getSubject() != null) {
            dto.setSubjectName(c.getSubject().getName());
            dto.setSubjectCode(c.getSubject().getCode());
        }
        return dto;
    }
}
