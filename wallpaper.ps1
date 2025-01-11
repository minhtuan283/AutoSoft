# Modify Path to the picture accordingly to reflect your infrastructure
$imgPath = "C:\Windows\Soft\Script\a.png"
$code = @'
using System.Runtime.InteropServices;
namespace Win32{
    public class Wallpaper{
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

        public static void SetWallpaper(string thePath){
            SystemParametersInfo(20, 0, thePath, 3);
        }
    }
}
'@

add-type $code

# Apply the Change on the system
# [Win32.Wallpaper]::SetWallpaper($imgPath)

# Đường dẫn đến khóa registry chứa cài đặt Background
$RegPath = "HKCU:\Control Panel\Desktop"

# Thiết lập chế độ hiển thị hình nền thành 'Stretch'
Set-ItemProperty -Path $RegPath -Name WallpaperStyle -Value 2
Set-ItemProperty -Path $RegPath -Name TileWallpaper -Value 0

Write-Host "Background mode: Fill -> Stretch" -ForegroundColor Green

# Áp dụng thay đổi ngay lập tức
[Win32.Wallpaper]::SetWallpaper($imgPath)


