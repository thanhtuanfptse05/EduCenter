@echo off
chcp 65001 > nul
title EduCenter ERP - Khởi tạo & Nạp CSDL 8 Bước

echo ===============================================================================
echo                 EDUCENTER ERP - DATABASE SETUP & SEED RUNNER
echo ===============================================================================
echo.
echo Đang gọi PowerShell để thực thi 8 file SQL seed...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_all_seeds.ps1" %*

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [LỖI] Có lỗi xảy ra trong quá trình nạp CSDL!
    echo Vui lòng kiểm tra lại SQL Server Service hoặc tài khoản kết nối.
) else (
    echo.
    echo [HOÀN TẤT] CSDL EduCenterDB đã sẵn sàng cho ứng dụng chạy!
)

echo.
echo Nhấn phím bất kỳ để thoát...
pause > nul
