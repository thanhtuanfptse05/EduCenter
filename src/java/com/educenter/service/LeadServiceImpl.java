package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.Consultation;
import com.educenter.entity.Lead;
import com.educenter.entity.User;
import com.educenter.repository.LeadRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Supplier;

public class LeadServiceImpl implements LeadService {

    private final LeadRepository leadRepository;
    private final Supplier<EntityManager> emSupplier;

    public LeadServiceImpl() {
        this(new LeadRepository(), () -> JPAUtil.getEntityManagerFactory().createEntityManager());
    }

    public LeadServiceImpl(LeadRepository leadRepository, Supplier<EntityManager> emSupplier) {
        this.leadRepository = leadRepository;
        this.emSupplier = emSupplier;
    }

    @Override
    public Map<String, Object> getLeadListPage(LeadFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            if (filter == null) {
                filter = new LeadFilterDTO();
            }

            long totalCount = leadRepository.countLeads(em, filter);
            List<Lead> leads = leadRepository.findLeads(em, filter);

            int pageSize = filter.getPageSize();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            if (totalPages == 0) totalPages = 1;

            List<LeadListItemDTO> dtoList = new ArrayList<>();
            for (Lead l : leads) {
                LeadListItemDTO item = new LeadListItemDTO();
                item.setId(l.getId());
                item.setName(l.getName());
                item.setPhone(l.getPhone());
                item.setEmail(l.getEmail());
                item.setGradeLevel(l.getGradeLevel());
                item.setSource(l.getSource());
                item.setStatus(l.getStatus());
                item.setNotes(l.getNotes());
                if (l.getAssignedTo() != null) {
                    item.setAssignedToId(l.getAssignedTo().getId());
                    item.setAssignedToName(l.getAssignedTo().getFullName());
                }
                item.setCreatedAt(l.getCreatedAt());
                item.setUpdatedAt(l.getUpdatedAt());
                dtoList.add(item);
            }

            Map<String, Long> stats = leadRepository.getLeadStats(em);

            Map<String, Object> result = new HashMap<>();
            result.put("leads", dtoList);
            result.put("totalCount", totalCount);
            result.put("totalPages", totalPages);
            result.put("currentPage", filter.getPage());
            result.put("pageSize", pageSize);
            result.put("stats", stats);

            return result;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public LeadDetailDTO getLeadDetail(Long leadId) {
        if (leadId == null) {
            throw new ValidationException("Mã Lead không hợp lệ.");
        }
        EntityManager em = emSupplier.get();
        try {
            Lead lead = leadRepository.findById(em, leadId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy thông tin Lead (ID: " + leadId + ")."));

            LeadDetailDTO dto = new LeadDetailDTO();
            dto.setId(lead.getId());
            dto.setName(lead.getName());
            dto.setPhone(lead.getPhone());
            dto.setEmail(lead.getEmail());
            dto.setGradeLevel(lead.getGradeLevel());
            dto.setSource(lead.getSource());
            dto.setStatus(lead.getStatus());
            dto.setNotes(lead.getNotes());
            if (lead.getAssignedTo() != null) {
                dto.setAssignedToId(lead.getAssignedTo().getId());
                dto.setAssignedToName(lead.getAssignedTo().getFullName());
            }
            dto.setCreatedAt(lead.getCreatedAt());
            dto.setUpdatedAt(lead.getUpdatedAt());

            // Consultations
            List<Consultation> consultations = leadRepository.findConsultationsByLeadId(em, leadId);
            List<ConsultationItemDTO> cList = new ArrayList<>();
            for (Consultation c : consultations) {
                ConsultationItemDTO cDto = new ConsultationItemDTO();
                cDto.setId(c.getId());
                cDto.setLeadId(leadId);
                if (c.getStaff() != null) {
                    cDto.setStaffId(c.getStaff().getId());
                    cDto.setStaffName(c.getStaff().getFullName());
                }
                cDto.setNotes(c.getNotes());
                cDto.setContactedAt(c.getContactedAt());
                cDto.setNextAppointment(c.getNextAppointment());
                cList.add(cDto);
            }
            dto.setConsultations(cList);

            // Staff list for assignment
            List<User> staffUsers = leadRepository.findStaffUsers(em);
            List<UserPrincipalDTO> staffList = new ArrayList<>();
            for (User u : staffUsers) {
                UserPrincipalDTO uDto = new UserPrincipalDTO();
                uDto.setUserId(u.getId());
                uDto.setFullName(u.getFullName());
                uDto.setEmail(u.getEmail());
                staffList.add(uDto);
            }
            dto.setStaffList(staffList);

            return dto;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public Lead createLead(LeadCreateFormDTO form, UserPrincipalDTO creator) {
        if (form == null) {
            throw new ValidationException("Dữ liệu Lead không được để trống.");
        }
        if (form.getName() == null || form.getName().trim().isEmpty()) {
            throw new ValidationException("Họ và tên khách hàng là bắt buộc.");
        }
        if (form.getPhone() == null || !form.getPhone().trim().matches("^(0|\\+84)[0-9]{9,10}$")) {
            throw new ValidationException("Số điện thoại không hợp lệ (yêu cầu định dạng 10 số bắt đầu bằng 0).");
        }
        if (form.getGradeLevel() != null && (form.getGradeLevel() < 6 || form.getGradeLevel() > 12)) {
            throw new ValidationException("Khối lớp bồi dưỡng phải từ lớp 6 đến lớp 12.");
        }

        String source = form.getSource();
        if (source == null || source.trim().isEmpty()) {
            source = "DIRECT";
        }
        Set<String> validSources = Set.of("WEBSITE", "FACEBOOK", "HOTLINE", "REFERRAL", "DIRECT");
        if (!validSources.contains(source.toUpperCase())) {
            source = "DIRECT";
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Lead lead = new Lead();
            lead.setName(form.getName().trim());
            lead.setPhone(form.getPhone().trim());
            lead.setEmail((form.getEmail() != null && !form.getEmail().trim().isEmpty()) ? form.getEmail().trim().toLowerCase() : null);
            lead.setGradeLevel(form.getGradeLevel());
            lead.setSource(source.toUpperCase());
            lead.setStatus("NEW");
            lead.setNotes(form.getNotes());
            lead.setCreatedAt(LocalDateTime.now());
            lead.setUpdatedAt(LocalDateTime.now());

            if (form.getAssignedToId() != null && form.getAssignedToId() > 0) {
                User staff = em.find(User.class, form.getAssignedToId());
                if (staff != null) {
                    lead.setAssignedTo(staff);
                }
            } else if (creator != null && creator.isStaff()) {
                User staff = em.find(User.class, creator.getUserId());
                if (staff != null) {
                    lead.setAssignedTo(staff);
                }
            }

            lead = leadRepository.save(em, lead);
            tx.commit();
            return lead;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) throw (ValidationException) e;
            throw new RuntimeException("Lỗi lưu trữ khách hàng tiềm năng: " + e.getMessage(), e);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public void updateLeadStatus(Long leadId, String newStatus, String notes, Long assignedToId, UserPrincipalDTO actor) {
        if (leadId == null) {
            throw new ValidationException("Mã Lead không hợp lệ.");
        }
        if (newStatus == null || newStatus.trim().isEmpty()) {
            throw new ValidationException("Vui lòng chọn trạng thái cần cập nhật.");
        }

        Set<String> validStatuses = Set.of("NEW", "CONTACTED", "ASSESSED", "CONSULTING", "ENROLLED", "LOST");
        if (!validStatuses.contains(newStatus.toUpperCase())) {
            throw new ValidationException("Trạng thái tư vấn không hợp lệ: " + newStatus);
        }

        // B10: Chặn chuyển sang ENROLLED thủ công (chỉ cập nhật qua giao dịch ghi danh)
        if ("ENROLLED".equalsIgnoreCase(newStatus.trim())) {
            throw new ValidationException("Không thể chuyển trực tiếp trạng thái sang ENROLLED. Trạng thái này chỉ được tự động ghi nhận khi hoàn tất thủ tục ghi danh vào lớp!");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Lead lead = leadRepository.findById(em, leadId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy Lead (ID: " + leadId + ")."));

            // B10: Kiểm tra quyền STAFF đối với Lead cụ thể
            if (actor != null && actor.isStaff() && !actor.isAdmin()) {
                if (lead.getAssignedTo() != null && !lead.getAssignedTo().getId().equals(actor.getUserId())) {
                    throw new ValidationException("Bạn chỉ có quyền cập nhật tiến trình tư vấn đối với các Lead được phân công cho mình!");
                }
            }

            lead.setStatus(newStatus.toUpperCase());
            if (notes != null && !notes.trim().isEmpty()) {
                if (lead.getNotes() != null && !lead.getNotes().isEmpty()) {
                    lead.setNotes(lead.getNotes() + "\n[" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) + "] " + notes.trim());
                } else {
                    lead.setNotes("[" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) + "] " + notes.trim());
                }
            }

            if (assignedToId != null) {
                if (assignedToId > 0) {
                    User staff = em.find(User.class, assignedToId);
                    if (staff != null) {
                        lead.setAssignedTo(staff);
                    }
                } else if (assignedToId == -1) {
                    lead.setAssignedTo(null);
                }
            }

            lead.setUpdatedAt(LocalDateTime.now());
            leadRepository.save(em, lead);
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) throw (ValidationException) e;
            throw new RuntimeException("Lỗi cập nhật trạng thái Lead: " + e.getMessage(), e);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public void addConsultation(ConsultationFormDTO form, UserPrincipalDTO staff) {
        if (form == null || form.getLeadId() == null) {
            throw new ValidationException("Thông tin tư vấn không hợp lệ.");
        }
        if (form.getNotes() == null || form.getNotes().trim().isEmpty()) {
            throw new ValidationException("Nội dung cuộc gọi / trao đổi tư vấn không được để trống.");
        }
        if (staff == null) {
            throw new ValidationException("Yêu cầu nhân viên đăng nhập để ghi nhận tư vấn.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Lead lead = leadRepository.findById(em, form.getLeadId())
                    .orElseThrow(() -> new ValidationException("Không tìm thấy Lead (ID: " + form.getLeadId() + ")."));

            User staffUser = em.find(User.class, staff.getUserId());
            if (staffUser == null) {
                throw new ValidationException("Nhân viên tư vấn không tồn tại trong hệ thống.");
            }

            Consultation c = new Consultation();
            c.setLead(lead);
            c.setStaff(staffUser);
            c.setNotes(form.getNotes().trim());
            c.setContactedAt(LocalDateTime.now());

            if (form.getNextAppointmentStr() != null && !form.getNextAppointmentStr().trim().isEmpty()) {
                try {
                    String dtStr = form.getNextAppointmentStr().trim();
                    if (dtStr.length() == 16) {
                        dtStr += ":00";
                    }
                    c.setNextAppointment(LocalDateTime.parse(dtStr));
                } catch (Exception ex) {
                    // Ignore parse error or keep null
                }
            }

            leadRepository.saveConsultation(em, c);

            // Auto transition status if currently NEW
            if ("NEW".equals(lead.getStatus())) {
                lead.setStatus("CONTACTED");
            }
            lead.setUpdatedAt(LocalDateTime.now());
            leadRepository.save(em, lead);

            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) throw (ValidationException) e;
            throw new RuntimeException("Lỗi lưu nhật ký tư vấn: " + e.getMessage(), e);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public Map<String, Long> getLeadStats() {
        EntityManager em = emSupplier.get();
        try {
            return leadRepository.getLeadStats(em);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
