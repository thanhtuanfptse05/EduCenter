# Specification Quality Checklist: Học phí, hóa đơn, thanh toán và công nợ

**Purpose:** Kiểm chất lượng đặc tả trước plan/tasks.
**Created/Reviewed:** 2026-10-23 | **Feature:** [spec.md](../spec.md) | **Baseline:** 2.0.0.

## Content Quality

- [x] Tập trung vào giá trị người dùng, phạm vi và hành vi có thể quan sát.
- [x] Các chi tiết kiến trúc dùng chung tách sang data-contract/integration; chỉ giữ ràng buộc bảo mật bắt buộc của dự án khi cần.
- [x] Actors, quyền và tất cả phần bắt buộc của Spec Kit đã có.
- [x] Nội dung viết để người phụ trách nghiệp vụ hiểu và nghiệm thu.

## Requirement Completeness

- [x] Không còn marker NEEDS CLARIFICATION hoặc placeholder trong spec hiện hành.
- [x] Mỗi FR có ID, yêu cầu, nguồn và kết quả nghiệm thu cụ thể.
- [x] Success criteria đo được bằng kết quả/nghiệm thu, không giả mạo số liệu vận hành.
- [x] Mỗi user story có ưu tiên, independent test và acceptance scenarios.
- [x] Có edge cases, lỗi input, trái quyền và tranh chấp liên quan.
- [x] Phạm vi trong/ngoài, phụ thuộc và giả định chính sách được ghi rõ.
- [x] Trạng thái/tiền/quyền/phân loại P0/P1 khớp hợp đồng chung.

## Feature Readiness

- [x] Mọi FR có cột nghiệm thu; các luồng chính và ngoại lệ được bao phủ.
- [x] Có link nguồn module, quyết định, dữ liệu, tích hợp và screen-map.
- [x] Đã đối chiếu ngữ nghĩa với baseline, không coi checklist triển khai cũ là bằng chứng hoàn thành.
- [x] Baseline sẵn sàng cho plan/tasks; không tuyên bố code hoặc runtime tests đã đạt.

## Notes

Reviewed theo yêu cầu chủ dự án và SRS v1.1; giả định chưa được khách hàng/giảng viên xác nhận được ghi tại decisions.md. Các dấu x chỉ xác nhận nội dung đặc tả đã được rà soát. Không xác nhận implementation, SQL Server/Tomcat/SMTP, UAT hoặc phê duyệt ngoài nhóm. Khi FR thay đổi phải kiểm lại checklist và plan/tasks.
