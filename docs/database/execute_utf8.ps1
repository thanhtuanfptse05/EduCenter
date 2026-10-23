# Script thực thi file SQL mã hóa UTF-8 trực tiếp qua .NET SqlConnection
param(
    [string]$Server = "localhost",
    [string]$Database = "EduCenterDB",
    [string]$User = "sa",
    [string]$Password = "123",
    [string]$SqlFile = "docs\database\seed_classes_timetable.sql"
)

$ErrorActionPreference = "Stop"

$fullPath = Resolve-Path $SqlFile
Write-Host "Dang thuc thi file SQL (UTF-8): $fullPath" -ForegroundColor Cyan

$connStr = "Server=$Server;Database=$Database;User Id=$User;Password=$Password;TrustServerCertificate=True;MultipleActiveResultSets=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection($connStr)
$connection.Open()

try {
    $content = [System.IO.File]::ReadAllText($fullPath, [System.Text.Encoding]::UTF8)
    # Tach cac batch theo keyword GO
    $batches = [System.Text.RegularExpressions.Regex]::Split($content, "(?im)^\s*GO\s*$", [System.Text.RegularExpressions.RegexOptions]::Multiline)

    foreach ($batch in $batches) {
        $trimmed = $batch.Trim()
        if (![string]::IsNullOrWhiteSpace($trimmed)) {
            $cmd = $connection.CreateCommand()
            $cmd.CommandText = $trimmed
            $cmd.CommandTimeout = 120
            $cmd.ExecuteNonQuery() | Out-Null
        }
    }
    Write-Host "[OK] Da thuc thi thanh cong toan bo file SQL voi chuan UTF-8 khong loi font!" -ForegroundColor Green
} finally {
    $connection.Close()
}
