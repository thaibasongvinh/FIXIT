param(
    [string]$DocxPath = "D:\Documents\MOBILEAPP\FLUTTER\ifixit\8_ TTTN_ThaiBaSongVinh_514240407_2026_UPDATED.docx"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$root = "D:\Documents\MOBILEAPP\FLUTTER\ifixit"
$diagramDir = Join-Path $root "docs\tttn_diagrams"
& (Join-Path $root "scripts\create_tttn_screenshots.ps1")

$workDir = Join-Path $root ("tttn_embed_work_" + [guid]::NewGuid().ToString('N').Substring(0,8))
$extractDir = Join-Path $workDir "doc"
New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($DocxPath, $extractDir)

$mediaDir = Join-Path $extractDir "word\media"
$xmlPath = Join-Path $extractDir "word\document.xml"
$relsPath = Join-Path $extractDir "word\_rels\document.xml.rels"

[xml]$xmlDoc = Get-Content $xmlPath -Encoding UTF8
[xml]$relsDoc = Get-Content $relsPath -Encoding UTF8
$ns = @{ w = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main' }
$body = $xmlDoc.DocumentElement.body

function Get-PlainText($node) {
    $texts = Select-Xml -Xml $node -XPath './/w:t' -Namespace $ns
    ($texts | ForEach-Object { $_.Node.'#text' }) -join ''
}

function Get-NextRelId {
    $max = 0
    foreach ($rel in $relsDoc.Relationships.Relationship) {
        if ($rel.Id -match '^rId(\d+)$') {
            $n = [int]$Matches[1]
            if ($n -gt $max) { $max = $n }
        }
    }
    return "rId$($max + 1)"
}

function Get-ImageEmu($path) {
    $img = [System.Drawing.Image]::FromFile($path)
    try {
        return @{
            Cx = [int64]($img.Width * 9525)
            Cy = [int64]($img.Height * 9525)
        }
    } finally { $img.Dispose() }
}

function Add-ImageRel($mediaName, $relId) {
    $rel = $relsDoc.CreateElement("Relationship", "http://schemas.openxmlformats.org/package/2006/relationships")
    $rel.SetAttribute("Id", $relId)
    $rel.SetAttribute("Type", "http://schemas.openxmlformats.org/officeDocument/2006/relationships/image")
    $rel.SetAttribute("Target", "media/$mediaName")
    $relsDoc.DocumentElement.AppendChild($rel) | Out-Null
}

function New-ImageParagraphXml($relId, $cx, $cy, $docPrId) {
    $cxHalf = [int64]($cx / 2)
    if ($cx -gt 5940000) {
        $scale = 5940000.0 / $cx
        $cx = 5940000
        $cy = [int64]($cy * $scale)
    }
    return @"
<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
     xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
     xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
     xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
     xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:pPr><w:jc w:val="center"/></w:pPr>
  <w:r><w:drawing>
    <wp:inline distT="0" distB="0" distL="0" distR="0">
      <wp:extent cx="$cx" cy="$cy"/>
      <wp:effectExtent l="0" t="0" r="0" b="0"/>
      <wp:docPr id="$docPrId" name="Picture $docPrId"/>
      <wp:cNvGraphicFramePr><a:graphicFrameLocks noChangeAspect="1"/></wp:cNvGraphicFramePr>
      <a:graphic><a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">
        <pic:pic>
          <pic:nvPicPr>
            <pic:cNvPr id="$docPrId" name="Picture $docPrId"/>
            <pic:cNvPicPr><a:picLocks noChangeAspect="1"/></pic:cNvPicPr>
          </pic:nvPicPr>
          <pic:blipFill><a:blip r:embed="$relId"/><a:stretch><a:fillRect/></a:stretch></pic:blipFill>
          <pic:spPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="$cx" cy="$cy"/></a:xfrm>
            <a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr>
        </pic:pic>
      </a:graphicData></a:graphic>
    </wp:inline>
  </w:drawing></w:r>
</w:p>
"@
}

function Insert-ImageBeforeCaption($caption, $imagePath) {
    $paras = @($body.ChildNodes | Where-Object { $_.LocalName -eq 'p' })
    $captionNode = $null
    foreach ($p in $paras) {
        $t = (Get-PlainText $p).Trim()
        if ($t -eq $caption) { $captionNode = $p; break }
    }
    if (-not $captionNode) {
        Write-Host "WARN: Caption not found: $caption"
        return
    }
    if ($captionNode.PreviousSibling -and (Get-PlainText $captionNode.PreviousSibling) -eq '') {
        $prev = $captionNode.PreviousSibling
        if ($prev.SelectSingleNode('.//w:drawing')) {
            Write-Host "SKIP (exists): $caption"
            return
        }
    }

    $ext = [System.IO.Path]::GetExtension($imagePath).TrimStart('.')
    $mediaIndex = (Get-ChildItem $mediaDir -Filter "tttn_*.*").Count + 1
    $mediaName = "tttn_$mediaIndex.$ext"
    Copy-Item $imagePath (Join-Path $mediaDir $mediaName) -Force

    $relId = Get-NextRelId
    Add-ImageRel $mediaName $relId
    $emu = Get-ImageEmu (Join-Path $mediaDir $mediaName)
    $docPrId = 900000 + $mediaIndex

    $xml = New-ImageParagraphXml $relId $emu.Cx $emu.Cy $docPrId
    $tmp = New-Object System.Xml.XmlDocument
    $tmp.LoadXml($xml)
    $imported = $xmlDoc.ImportNode($tmp.DocumentElement, $true)
    $body.InsertBefore($imported, $captionNode) | Out-Null
    Write-Host "OK: $caption"
}

$map = @(
    @{ Cap = 'Hình 4.1. Sơ đồ Use case tổng quát hệ thống FixIt'; File = 'usecase.png' }
    @{ Cap = 'Hình 4.2. Sơ đồ quan hệ cơ sở dữ liệu FixIt (ERD)'; File = 'erd.png' }
    @{ Cap = 'Hình 4.3. Sơ đồ kiến trúc tổng quan ứng dụng FixIt'; File = 'architecture.png' }
    @{ Cap = 'Hình 5.1. Giao diện đăng nhập ứng dụng FixIt'; File = 'screen_login.png' }
    @{ Cap = 'Hình 5.2. Luồng xử lý đăng nhập qua Appwrite'; File = 'login_flow.png' }
    @{ Cap = 'Hình 5.3. Giao diện trang chủ ứng dụng FixIt'; File = 'screen_home.png' }
    @{ Cap = 'Hình 5.4. Giao diện bản đồ kỹ thuật viên'; File = 'screen_map.png' }
    @{ Cap = 'Hình 5.5. Giao diện quản trị Admin Dashboard'; File = 'screen_admin.png' }
)

foreach ($item in $map) {
    $imgPath = Join-Path $diagramDir $item.File
    if (Test-Path $imgPath) {
        Insert-ImageBeforeCaption $item.Cap $imgPath
    } else {
        Write-Host "MISSING: $($item.File)"
    }
}

# Sua ngay ky + ket luan AI
$tNodes = Select-Xml -Xml $xmlDoc -XPath '//w:t' -Namespace $ns
foreach ($tn in $tNodes) {
    $v = $tn.Node.'#text'
    if (-not $v) { continue }
    if ($v -like '*ngày … tháng … năm 2026*') {
        $tn.Node.'#text' = $v.Replace('ngày … tháng … năm 2026', 'ngày 03 tháng 07 năm 2026')
    }
    if ($v -like '*search, AI diagnosis và admin dashboard*') {
        $tn.Node.'#text' = 'search và admin dashboard (chức năng AI diagnosis đang phát triển qua feature flag trên Appwrite).'
    }
}

$xmlDoc.Save($xmlPath)
$relsDoc.Save($relsPath)
Remove-Item $DocxPath -Force
[System.IO.Compression.ZipFile]::CreateFromDirectory($extractDir, $DocxPath)
Remove-Item $workDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Embedded images -> $DocxPath"
