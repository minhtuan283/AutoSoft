
# Tắt thông báo lỗi
$ErrorActionPreference = "SilentlyContinue"

# DellOptimizer
Write-Host "`n=== DellOptimizer ==="
Get-ChildItem -Recurse -Path "C:\Program Files (x86)\InstallShield Installation Information" -Filter "DellOptimizer_MyDell.exe" -File | ForEach-Object {
    Write-Host "File found: $($_.FullName)"
    Start-Process $_.FullName -ArgumentList "-modify -runfromtemp -remove" -Wait
    return
}

# ExpressVPN
$appName = "ExpressVPN"
# Đường dẫn Registry chứa thông tin gỡ cài đặt cho 32-bit và 64-bit ứng dụng
$uninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)
# Tìm ProductCode
$productCode = $null
foreach ($keyPath in $uninstallKeys) {
    $product = Get-ChildItem -Path $keyPath | Where-Object {
        $_.GetValue("DisplayName") -like "*$appName*"
    }
    if ($product) {
        $productCode = $product.PSChildName
        Write-Host "Tim thay : $productCode"
        break
    }
}
# Kiểm tra nếu tìm thấy ProductCode và tiến hành gỡ cài đặt
if ($productCode) {
    Write-Host "Dang go cai dat ung dung: $appName"
    Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/x $productCode /qn" -Wait
    Write-Host "Qua trinh go cai dat hoan tat."
} else {
    Write-Host "Khong tim thay ung dung: $appName"
}


# Dell Digital Delivery Services
$appName = "Dell Digital Delivery Services"
# Đường dẫn Registry chứa thông tin gỡ cài đặt cho 32-bit và 64-bit ứng dụng
$uninstallKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)
# Tìm ProductCode
$productCode = $null
foreach ($keyPath in $uninstallKeys) {
    $product = Get-ChildItem -Path $keyPath | Where-Object {
        $_.GetValue("DisplayName") -like "*$appName*"
    }
    if ($product) {
        $productCode = $product.PSChildName
        Write-Host "Tim thay : $productCode"
        break
    }
}
# Kiểm tra nếu tìm thấy ProductCode và tiến hành gỡ cài đặt
if ($productCode) {
    Write-Host "Dang go cai dat ung dung: $appName"
    Start-Process "C:\Windows\System32\msiexec.exe" -ArgumentList "/x $productCode /qn" -Wait
    Write-Host "Qua trinh go cai dat hoan tat."
} else {
    Write-Host "Khong tim thay ung dung: $appName"
}

# McAfee 1 ok
Write-Host "`n=== McAfee 1 ==="
Get-ChildItem -Recurse -Path "C:\Program Files\McAfee\MSC" -Filter "mcuihost*.exe" -File | ForEach-Object {
    Write-Host "File found: $($_.FullName)"
    Start-Process $_.FullName -ArgumentList "/body:misp://MSCJsRes.dll::uninstall.html /id:uninstall"
    return
}


# McAfee New ok
Write-Host "`n=== McAfee New ==="
Get-ChildItem -Recurse -Path "C:\Program Files\McAfee\WPS" -Filter "mc-update*.exe" -File | ForEach-Object {
    Write-Host "File found: $($_.FullName)"
    Start-Process $_.FullName -ArgumentList "/uninstall /quiet"
    return
}

# Norton ok
Write-Host "`n=== Norton ==="
Get-ChildItem -Recurse -Path "C:\Program Files (x86)\NortonInstaller" -Filter "InstStub*.exe" -File | ForEach-Object {
    Write-Host "File found: $($_.FullName)"
    Start-Process $_.FullName -ArgumentList "/X /ARP"
    return
}

