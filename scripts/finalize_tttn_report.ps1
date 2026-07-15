# Finalize bao cao TTTN: patch noi dung + chen hinh + ngay ky
$ErrorActionPreference = "Stop"
$root = "D:\Documents\MOBILEAPP\FLUTTER\ifixit"
$patchScript = Join-Path $root "scripts\patch_tttn_xml.ps1"
$embedScript = Join-Path $root "scripts\embed_tttn_images.ps1"

& $patchScript

$dest = Join-Path $root "8_ TTTN_ThaiBaSongVinh_514240407_2026_UPDATED.docx"
& $embedScript -DocxPath $dest

Write-Host "FINAL: $dest"
