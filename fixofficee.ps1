# 1. Đường dẫn tải file (Tôi đã chuyển sang link RAW chuẩn cho bạn)
$url = "https://github.com/minhtuan283/AutoSoft/raw/main/FixOffice.diagcab"
$output = "$env:TEMP\FixOffice.diagcab"

# 2. Tải file về thư mục Temp
Write-Host "Fix Office by TangTuan" -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop
}
catch {
    Write-Host "Loi tai file! Kiem tra lai mang hoac link GitHub." -ForegroundColor Red
    exit
}

# 3. Chạy file diagcab
Write-Host "Dang khoi chay..." -ForegroundColor Green
Start-Process -FilePath $output
