# Patch TTTN docx via document.xml (no Word COM)
$ErrorActionPreference = "Stop"
$root = "D:\Documents\MOBILEAPP\FLUTTER\ifixit"
$src = Join-Path $root "8_ TTTN_ThaiBaSongVinh_514240407_2026_BACKUP.docx"
if (-not (Test-Path $src)) { $src = Join-Path $root "8_ TTTN_ThaiBaSongVinh_514240407_2026.docx" }
$dest = Join-Path $root "8_ TTTN_ThaiBaSongVinh_514240407_2026_UPDATED.docx"
$contentPath = Join-Path $root "docs\TTTN_BO_SUNG_CHUONG_2_4_5.txt"
$workDir = Join-Path $root "tttn_patch_work"
$zipPath = Join-Path $workDir "doc.zip"

if (Test-Path $workDir) { Remove-Item $workDir -Recurse -Force }
New-Item -ItemType Directory -Path $workDir | Out-Null
Copy-Item $src $dest -Force
Copy-Item $dest $zipPath -Force
Expand-Archive $zipPath -DestinationPath $workDir -Force

$xmlPath = Join-Path $workDir "word\document.xml"
[xml]$xmlDoc = Get-Content $xmlPath -Encoding UTF8
$nsUri = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
$ns = @{ w = $nsUri }

function Get-PlainText($node) {
    $texts = Select-Xml -Xml $node -XPath './/w:t' -Namespace $ns
    ($texts | ForEach-Object { $_.Node.'#text' }) -join ''
}

function New-WordParagraph([string]$text) {
    $p = $xmlDoc.CreateElement('w:p', $nsUri)
    $r = $xmlDoc.CreateElement('w:r', $nsUri)
    $t = $xmlDoc.CreateElement('w:t', $nsUri)
    $t.SetAttribute('xml:space', 'preserve')
    $t.InnerText = $text
    $r.AppendChild($t) | Out-Null
    $p.AppendChild($r) | Out-Null
    return $p
}

function Get-SectionText($raw, $name) {
    if ($raw -match "===$name===([\s\S]*?)(?====|$)") { return $Matches[1].Trim() }
    return ""
}

$raw = Get-Content $contentPath -Raw -Encoding UTF8
$sec22 = Get-SectionText $raw "INSERT_2_2"
$secCh45 = Get-SectionText $raw "REPLACE_CH4_CH5"
$secHinh = Get-SectionText $raw "REPLACE_DANH_MUC_HINH"
$secBang = Get-SectionText $raw "REPLACE_DANH_MUC_BANG"
$secTL = Get-SectionText $raw "REPLACE_TAI_LIEU"

$body = $xmlDoc.DocumentElement.body

$script:paras = @()
$script:paraTexts = @()

function Refresh-Paras {
    $script:paras = @($body.ChildNodes | Where-Object { $_.LocalName -eq 'p' })
    $script:paraTexts = @()
    for ($i = 0; $i -lt $script:paras.Count; $i++) {
        $script:paraTexts += [PSCustomObject]@{
            Index = $i
            Text  = (Get-PlainText $script:paras[$i]).Trim()
        }
    }
}

Refresh-Paras

# Text replacements in w:t nodes
$replacements = [ordered]@{
    'CHƯƠNG 5. XÂY DỰNG WEBSITE' = 'CHƯƠNG 5. XÂY DỰNG ỨNG DỤNG DI ĐỘNG'
    'XÂY DỰNG MOBILE' = 'CHƯƠNG 5. XÂY DỰNG ỨNG DỤNG DI ĐỘNG'
    'Hình .5.8' = 'Hình 2.5.8'
    'Hình 51:' = 'Hình 5.1.'
    'Hình 52:' = 'Hình 5.2.'
    'nghành' = 'ngành'
    'Sự kiện nổi ' = 'Sự kiện nổi bật '
    'ngày   tháng   năm 2025' = 'ngày … tháng … năm 2026'
    'Fixit Vietnam' = 'FixIt'
    'FIXIT' = 'FixIt'
}
$tNodes = Select-Xml -Xml $xmlDoc -XPath '//w:t' -Namespace $ns
foreach ($tn in $tNodes) {
    $val = $tn.Node.'#text'
    if (-not $val) { continue }
    foreach ($k in $replacements.Keys) {
        if ($val.Contains($k)) { $tn.Node.'#text' = $val.Replace($k, $replacements[$k]); $val = $tn.Node.'#text' }
    }
}

Refresh-Paras

function Remove-ParaRange($startIdx, $endIdx) {
    for ($i = $endIdx; $i -ge $startIdx; $i--) { $body.RemoveChild($script:paras[$i]) | Out-Null }
}

function Remove-BodyChildrenAfter($node) {
    while ($node.NextSibling) {
        $body.RemoveChild($node.NextSibling) | Out-Null
    }
}

function Insert-LinesAfter($afterIdx, [string[]]$lines) {
    $refNode = $script:paras[$afterIdx]
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $newP = New-WordParagraph $line
        $body.InsertAfter($newP, $refNode) | Out-Null
        $refNode = $newP
    }
}

# 2.2 — insert after Bảng 2.3
$idxB23 = ($script:paraTexts | Where-Object { $_.Text -like 'Bảng 2.3*' } | Select-Object -First 1).Index
if ($null -ne $idxB23) {
    Insert-LinesAfter $idxB23 ($sec22 -split "`r?`n")
    Refresh-Paras
    Write-Host "Inserted section 2.2"
}

# Ch4-5: replace from "Sơ đồ Use case" through end of old Ch5 (before KẾT LUẬN)
$idxThietKe = ($script:paraTexts | Where-Object { $_.Text -eq 'THIẾT KẾ HỆ THỐNG' } | Select-Object -Last 1).Index
$idxUC = ($script:paraTexts | Where-Object { $_.Index -gt $idxThietKe -and $_.Text -eq 'Sơ đồ Use case' } | Select-Object -First 1).Index
$idxKL = ($script:paraTexts | Where-Object { $_.Text -like 'KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN' } | Select-Object -First 1).Index
if ($null -ne $idxUC -and $null -ne $idxKL -and $idxKL -gt $idxUC) {
    Remove-ParaRange $idxUC ($idxKL - 1)
    Refresh-Paras
    $idxInsert = ($script:paraTexts | Where-Object { $_.Text -eq 'THIẾT KẾ HỆ THỐNG' } | Select-Object -Last 1).Index
    Insert-LinesAfter $idxInsert ($secCh45 -split "`r?`n")
    Refresh-Paras
    Write-Host "Inserted Ch4-5: $($secCh45.Length) chars"
} else {
    Write-Host "WARN: Ch4-5 indices UC=$idxUC KL=$idxKL TK=$idxThietKe"
}

# Danh muc hinh
$idxDH = ($script:paraTexts | Where-Object { $_.Text -eq 'DANH MỤC HÌNH ẢNH' } | Select-Object -Last 1).Index
$idxDB = ($script:paraTexts | Where-Object { $_.Text -eq 'DANH MỤC BẢNG BIỂU' } | Select-Object -Last 1).Index
if ($null -ne $idxDH -and $null -ne $idxDB -and $idxDB -gt ($idxDH + 1)) {
    Remove-ParaRange ($idxDH + 1) ($idxDB - 1)
    Refresh-Paras
    $idxDH2 = ($script:paraTexts | Where-Object { $_.Text -eq 'DANH MỤC HÌNH ẢNH' } | Select-Object -Last 1).Index
    $linesH = ($secHinh -split "`r?`n" | Where-Object { $_ -notmatch '^DANH MỤC HÌNH' -and $_.Trim() -ne '' })
    Insert-LinesAfter $idxDH2 $linesH
    Refresh-Paras
}

# Danh muc bang
$idxDB2 = ($script:paraTexts | Where-Object { $_.Text -eq 'DANH MỤC BẢNG BIỂU' } | Select-Object -Last 1).Index
$idxGT = ($script:paraTexts | Where-Object { $_.Text -eq 'GIỚI THIỆU' -and $_.Index -gt $idxDB2 } | Select-Object -First 1).Index
if ($null -ne $idxDB2 -and $null -ne $idxGT -and $idxGT -gt ($idxDB2 + 1)) {
    Remove-ParaRange ($idxDB2 + 1) ($idxGT - 1)
    Refresh-Paras
    $idxDB3 = ($script:paraTexts | Where-Object { $_.Text -eq 'DANH MỤC BẢNG BIỂU' } | Select-Object -Last 1).Index
    $linesB = ($secBang -split "`r?`n" | Where-Object { $_ -notmatch '^DANH MỤC BẢNG' -and $_.Trim() -ne '' })
    Insert-LinesAfter $idxDB3 $linesB
    Refresh-Paras
}

# Tai lieu tham khao — remove everything after last heading in body
Refresh-Paras
$idxTL = ($script:paraTexts | Where-Object { $_.Text -eq 'TÀI LIỆU THAM KHẢO' } | Select-Object -Last 1).Index
if ($null -ne $idxTL) {
    $tlNode = $script:paras[$idxTL]
    Remove-BodyChildrenAfter $tlNode
    Insert-LinesAfter $idxTL ($secTL -split "`r?`n")
    Write-Host "Updated Tai lieu tham khao"
}

# Remove duplicate cover page (2nd "BỘ GIÁO DỤC" block)
Refresh-Paras
$bogd = @($script:paraTexts | Where-Object { $_.Text -eq 'BỘ GIÁO DỤC VÀ ĐÀO TẠO' })
if ($bogd.Count -ge 2) {
    $startDup = $bogd[1].Index
    $idxLM = ($script:paraTexts | Where-Object { $_.Index -gt $startDup -and $_.Text -eq 'LỜI MỞ ĐẦU' } | Select-Object -First 1).Index
    if ($null -ne $idxLM -and $idxLM -gt $startDup) {
        Remove-ParaRange $startDup ($idxLM - 1)
        Write-Host "Removed duplicate cover"
    }
}

$xmlDoc.Save($xmlPath)
Remove-Item $dest -Force
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($workDir, $dest)
Write-Host "OK: $dest"
