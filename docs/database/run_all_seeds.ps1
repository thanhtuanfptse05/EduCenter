# ==============================================================================
# EduCenter ERP - Script Tự Động Khởi Tạo & Nạp Dữ Liệu Mẫu Toàn Diện (8 Bước)
# Hệ QT CSDL: Microsoft SQL Server (Hỗ trợ cả Windows Auth và SQL Auth)
# ==============================================================================

[CmdletBinding()]
param(
    [string]$Server = "localhost",
    [string]$Database = "EduCenterDB",
    [string]$User = "sa",
    [string]$Password = "123",
    [switch]$UseWindowsAuth
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$seedsDir = Join-Path $scriptDir "seeds"

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "                EDUCENTER ERP - DATABASE SETUP & SEED RUNNER                   " -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host " Server:       $Server" -ForegroundColor Gray
Write-Host " Database:     $Database" -ForegroundColor Gray
if ($UseWindowsAuth) {
    Write-Host " Auth Mode:    Windows Authentication (-E)" -ForegroundColor Gray
} else {
    Write-Host " Auth Mode:    SQL Server Authentication (User: $User)" -ForegroundColor Gray
}
Write-Host " Seeds Folder: $seedsDir" -ForegroundColor Gray
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

# Danh sách 8 file script SQL theo thứ tự ràng buộc khóa ngoại chuẩn
$seedFiles = @(
    @{ Step = "1/8"; Name = "Khởi tạo CSDL & 30 Bảng Chuẩn (Schema Baseline)"; File = "01_schema_baseline.sql" },
    @{ Step = "2/8"; Name = "Cấu hình Hệ thống & 5 Vai trò Quyền hạn (Roles & Settings)"; File = "02_roles_and_settings.sql" },
    @{ Step = "3/8"; Name = "Môn học & 15 Khóa học THCS-THPT (Subjects & Courses)"; File = "03_subjects_and_courses.sql" },
    @{ Step = "4/8"; Name = "Người dùng, Giáo viên, Nhân viên, Học viên & Phụ huynh"; File = "04_users_teachers_staff_students.sql" },
    @{ Step = "5/8"; Name = "Phòng học & 14 Lớp học Chuyên đề / Luyện thi"; File = "05_rooms_and_classes.sql" },
    @{ Step = "6/8"; Name = "Thời khóa biểu & Lịch học Chi tiết 50+ Buổi"; File = "06_timetables_and_sessions.sql" },
    @{ Step = "7/8"; Name = "Ghi danh (22 Học viên), Hóa đơn & Biên lai Thanh toán"; File = "07_enrollments_invoices_payments.sql" },
    @{ Step = "8/8"; Name = "Điểm danh, Sổ đầu bài, Điểm kiểm tra, Leads CRM & Audit"; File = "08_attendance_assessments_leads.sql" }
)

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$successCount = 0

foreach ($item in $seedFiles) {
    $filePath = Join-Path $seedsDir $item.File
    Write-Host "[$($item.Step)] Đang nạp: $($item.Name)..." -ForegroundColor Yellow -NoNewline

    if (-not (Test-Path $filePath)) {
        Write-Host " [THẤT BẠI]" -ForegroundColor Red
        Write-Error "Không tìm thấy file: $filePath"
        exit 1
    }

    $cmdArgs = @("-I", "-b", "-S", $Server)
    if ($UseWindowsAuth) {
        $cmdArgs += "-E"
    } else {
        $cmdArgs += @("-U", $User, "-P", $Password)
    }
    $cmdArgs += @("-i", $filePath)

    $output = & sqlcmd $cmdArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host " [LỖI]" -ForegroundColor Red
        Write-Host ""
        Write-Host "Chi tiết lỗi khi thực thi file $($item.File):" -ForegroundColor Red
        Write-Host $output -ForegroundColor Red
        exit $LASTEXITCODE
    } else {
        Write-Host " [THÀNH CÔNG]" -ForegroundColor Green
        $successCount++
    }
}

$stopwatch.Stop()

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "                NẠP DỮ LIỆU CSDL EDUCENTER THÀNH CÔNG 100%!                    " -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host " Tổng số bước hoàn tất: $successCount / $($seedFiles.Count)" -ForegroundColor White
Write-Host " Thời gian thực thi:    $([math]::Round($stopwatch.Elapsed.TotalSeconds, 2)) giây" -ForegroundColor White
Write-Host ""
Write-Host " THÔNG TIN ĐĂNG NHẬP HỆ THỐNG MẪU (Mật khẩu mặc định: 123456):" -ForegroundColor Cyan
Write-Host "  * Quản trị viên (ADMIN):      admin@educenter.edu.vn" -ForegroundColor White
Write-Host "  * Quản lý học vụ (ACADEMIC):  academic@educenter.edu.vn" -ForegroundColor White
Write-Host "  * Giáo viên (TEACHER):        thanh.nv@educenter.edu.vn | minh.tran@educenter.edu.vn" -ForegroundColor White
Write-Host "  * Nhân viên tư vấn (STAFF):   staff1@educenter.edu.vn | staff2@educenter.edu.vn" -ForegroundColor White
Write-Host "  * Học viên (STUDENT):         nam.nguyen@student.edu.vn | mai.le@student.edu.vn" -ForegroundColor White
Write-Host "  * Phụ huynh (PARENT):         ph.namnguyen@gmail.com | ph.mai@gmail.com" -ForegroundColor White
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""
