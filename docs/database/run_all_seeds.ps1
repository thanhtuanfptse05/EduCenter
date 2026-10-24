# ==============================================================================
# EduCenter ERP - Script Tu Dong Khoi Tao & Nap Du Lieu Mau Toan Dien (8 Buoc)
# He QT CSDL: Microsoft SQL Server (Ho tro ca Windows Auth va SQL Auth)
# ==============================================================================

[CmdletBinding()]
param(
    [string]$Server = "localhost",
    [string]$Database = "EduCenterDB",
    [string]$User = "sa",
    [string]$Password = "123",
    [switch]$UseWindowsAuth
)

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

$seedFiles = @(
    @{ Step = "1/8"; Name = "Khoi tao CSDL & 30 Bang Chuan (Schema Baseline)"; File = "01_schema_baseline.sql" },
    @{ Step = "2/8"; Name = "Cau hinh He thong & 5 Vai tro Quyen han (Roles & Settings)"; File = "02_roles_and_settings.sql" },
    @{ Step = "3/8"; Name = "Mon hoc & 15 Khoa hoc THCS-THPT (Subjects & Courses)"; File = "03_subjects_and_courses.sql" },
    @{ Step = "4/8"; Name = "Nguoi dung, Giao vien, Nhan vien, Hoc vien & Phu huynh"; File = "04_users_teachers_staff_students.sql" },
    @{ Step = "5/8"; Name = "Phong hoc & 14 Lop hoc Chuyen de / Luyen thi"; File = "05_rooms_and_classes.sql" },
    @{ Step = "6/8"; Name = "Thoi khoa bieu & Lich hoc Chi tiet 50+ Buoi"; File = "06_timetables_and_sessions.sql" },
    @{ Step = "7/8"; Name = "Ghi danh (22 Hoc vien), Hoa don & Bien lai Thanh toan"; File = "07_enrollments_invoices_payments.sql" },
    @{ Step = "8/8"; Name = "Diem danh, So dau bai, Diem kiem tra, Leads CRM & Audit"; File = "08_attendance_assessments_leads.sql" }
)

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$successCount = 0

foreach ($item in $seedFiles) {
    $filePath = Join-Path $seedsDir $item.File
    Write-Host ("[" + $item.Step + "] Dang nap: " + $item.Name + "...") -ForegroundColor Yellow -NoNewline

    if (-not (Test-Path $filePath)) {
        Write-Host " [THAT BAI]" -ForegroundColor Red
        Write-Error ("Khong tim thay file: " + $filePath)
        exit 1
    }

    $cmdArgs = @("-I", "-b", "-S", $Server, "-d", $Database)
    if ($UseWindowsAuth) {
        $cmdArgs += "-E"
    } else {
        $cmdArgs += @("-U", $User, "-P", $Password)
    }
    $cmdArgs += @("-i", $filePath)

    $output = & sqlcmd $cmdArgs 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host " [LOI]" -ForegroundColor Red
        Write-Host ""
        Write-Host ("Chi tiet loi khi thuc thi file " + $item.File + ":") -ForegroundColor Red
        Write-Host $output -ForegroundColor Red
        exit $LASTEXITCODE
    } else {
        Write-Host " [THANH CONG]" -ForegroundColor Green
        $successCount++
    }
}

$stopwatch.Stop()

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host "                NAP DU LIEU CSDL EDUCENTER THANH CONG 100%!                    " -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host (" Tong so buoc hoan tat: " + $successCount + " / " + $seedFiles.Count) -ForegroundColor White
Write-Host (" Thoi gian thuc thi:    " + [math]::Round($stopwatch.Elapsed.TotalSeconds, 2) + " giay") -ForegroundColor White
Write-Host ""
Write-Host " THONG TIN DANG NHAP HE THONG MAU (Mat khau mac dinh: 123456):" -ForegroundColor Cyan
Write-Host "  * Quan tri vien (ADMIN):      admin@educenter.vn" -ForegroundColor White
Write-Host "  * Giao vien (TEACHER):        teacher.hung@educenter.vn" -ForegroundColor White
Write-Host "  * Nhan vien tu van (STAFF):   staff@educenter.vn" -ForegroundColor White
Write-Host "  * Hoc vien (STUDENT):         student.nam@educenter.vn" -ForegroundColor White
Write-Host "  * Phu huynh (PARENT):         parent.tuan@educenter.vn" -ForegroundColor White
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""
