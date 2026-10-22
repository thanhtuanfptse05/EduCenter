# ==============================================================================
# EduCenter - Script Khoi tao & Dong bo Co so Du lieu Microsoft SQL Server
# ==============================================================================

param(
    [string]$Server = "localhost",
    [string]$User = "sa",
    [string]$Password = "123"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " EDUCENTER - KHOI TAO & DONG BO CSDL SQL SERVER" -ForegroundColor Cyan
Write-Host " Server: $Server | User: $User" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$files = @(
    @{ Name = "[1/4] Schema 31 bang & Du lieu goc"; Path = Join-Path $scriptDir "EduCenter_Schema_SQLServer.sql" },
    @{ Name = "[2/4] Migration 001: Password Reset Tokens"; Path = Join-Path $scriptDir "migrations\001-auth-password-reset.sql" },
    @{ Name = "[3/4] Migration 002: Giang vien, Mon hoc & Khoa hoc THPT"; Path = Join-Path $scriptDir "migrations\002-landing-portal-seed.sql" },
    @{ Name = "[4/4] Migration 003: Cap nhat duong dan anh cuc bo"; Path = Join-Path $scriptDir "migrations\003-update-local-images.sql" }
)

foreach ($item in $files) {
    Write-Host "--> Dang chay: $($item.Name)..." -ForegroundColor Yellow
    if (-not (Test-Path $item.Path)) {
        Write-Error "Khong tim thay file: $($item.Path)"
    }
    
    & sqlcmd -I -S $Server -U $User -P $Password -i $item.Path
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Loi xay ra khi chay file: $($item.Path)"
    }
    Write-Host "    [OK] Hoan tat: $($item.Name)" -ForegroundColor Green
    Write-Host ""
}

Write-Host "=================================================================" -ForegroundColor Green
Write-Host " KHOI TAO VA DONG BO DU LIEU THANH CONG 100%!" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
