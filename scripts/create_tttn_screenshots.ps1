# Tao anh mock UI cho bao cao TTTN
Add-Type -AssemblyName System.Drawing
$outDir = "D:\Documents\MOBILEAPP\FLUTTER\ifixit\docs\tttn_diagrams"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

function New-PhoneMock {
    param(
        [string]$Path,
        [string]$Title,
        [string[]]$Lines,
        [int]$AccentR = 37, [int]$AccentG = 99, [int]$AccentB = 235
    )
    $w = 540; $h = 960
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'AntiAlias'
    $g.Clear([System.Drawing.Color]::FromArgb(245, 247, 250))

    $phoneRect = New-Object System.Drawing.Rectangle 40, 40, ($w - 80), ($h - 80)
    $g.FillRectangle([System.Drawing.Brushes]::White, $phoneRect)
    $g.DrawRectangle((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(220, 220, 220), 2)), $phoneRect)

    $accentBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($AccentR, $AccentG, $AccentB))
    $g.FillRectangle($accentBrush, 40, 40, ($w - 80), 90)
    $titleFont = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Bold)
    $g.DrawString($Title, $titleFont, [System.Drawing.Brushes]::White, 60, 70)

    $bodyFont = New-Object System.Drawing.Font('Segoe UI', 11)
    $y = 160
    foreach ($line in $Lines) {
        if ($line -eq '---') {
            $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230,230,230))), 70, $y, 400, 42)
            $y += 58
            continue
        }
        $g.DrawString($line, $bodyFont, [System.Drawing.Brushes]::Black, 70, $y)
        $y += 34
    }

    $badgeFont = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Italic)
    $g.DrawString('FixIt Mobile App - Mock UI', $badgeFont, [System.Drawing.Brushes]::Gray, 60, ($h - 95))
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
}

New-PhoneMock "$outDir\screen_login.png" "Đăng nhập FixIt" @(
    'Email: songvinh@email.com'
    'Mật khẩu: ********'
    '---'
    '[  Đăng nhập  ]'
    'Hoặc đăng nhập bằng Google'
)

New-PhoneMock "$outDir\screen_home.png" "Trang chủ FixIt" @(
    'Tìm kiếm dịch vụ...'
    '---'
    'Banner khuyến mãi'
    'Dịch vụ phổ biến: Sửa điện thoại'
    'KTV gần bạn: Nguyễn Văn A ★4.8'
) -AccentR 14 -AccentG 165 -AccentB 233

New-PhoneMock "$outDir\screen_map.png" "Bản đồ KTV" @(
    'Vị trí hiện tại: Quận Gò Vấp'
    '---'
    '[   Bản đồ Google Maps   ]'
    '• KTV A - 1.2 km'
    '• KTV B - 2.5 km'
) -AccentR 22 -AccentG 163 -AccentB 74

New-PhoneMock "$outDir\screen_admin.png" "Admin Dashboard" @(
    'Tổng users: 128'
    'Đơn chờ duyệt: 5'
    '---'
    'Duyệt KTV | Bookings'
    'Services | Banners | Finance'
) -AccentR 124 -AccentG 58 -AccentB 237

Write-Host "Created mock screenshots in $outDir"
