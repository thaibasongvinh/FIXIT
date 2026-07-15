# Script cập nhật báo cáo TTTN bằng Microsoft Word COM
$ErrorActionPreference = "Stop"
$docPath = "D:\Documents\MOBILEAPP\FLUTTER\ifixit\8_ TTTN_ThaiBaSongVinh_514240407_2026.docx"
$contentPath = "D:\Documents\MOBILEAPP\FLUTTER\ifixit\docs\TTTN_BO_SUNG_CHUONG_2_4_5.txt"
$backupPath = "D:\Documents\MOBILEAPP\FLUTTER\ifixit\8_ TTTN_ThaiBaSongVinh_514240407_2026_BACKUP.docx"

# Backup
Copy-Item $docPath $backupPath -Force
Write-Host "Backup: $backupPath"

# Load content sections
$raw = Get-Content $contentPath -Raw -Encoding UTF8
function Get-Section($name) {
    $pattern = "===$name===(.*?)(?====|$)"
    if ($raw -match $pattern) { return $Matches[1].Trim() }
    return ""
}

$sec22 = Get-Section "INSERT_2_2"
$secCh45 = Get-Section "REPLACE_CH4_CH5"
$secHinh = Get-Section "REPLACE_DANH_MUC_HINH"
$secBang = Get-Section "REPLACE_DANH_MUC_BANG"
$secTL = Get-Section "REPLACE_TAI_LIEU"

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

try {
    $doc = $word.Documents.Open($docPath)

    # --- Find & Replace fixes ---
    $replacements = @(
        @("CHƯƠNG 5. XÂY DỰNG WEBSITE", "CHƯƠNG 5. XÂY DỰNG ỨNG DỤNG DI ĐỘNG"),
        @("XÂY DỰNG MOBILE", "CHƯƠNG 5. XÂY DỰNG ỨNG DỤNG DI ĐỘNG"),
        @("Hình .5.8", "Hình 2.5.8"),
        @("Hình 51:", "Hình 5.1."),
        @("Hình 52:", "Hình 5.2."),
        @("nghành", "ngành"),
        @("Sự kiện nổi ", "Sự kiện nổi bật"),
        @("ngày   tháng   năm 2025", "ngày … tháng … năm 2026"),
        @("Fixit Vietnam", "FixIt"),
        @("Fixit", "FixIt"),
        @("FIXIT", "FixIt")
    )

    foreach ($r in $replacements) {
        $find = $doc.Content.Find
        $find.ClearFormatting()
        $find.Replacement.ClearFormatting()
        $null = $find.Execute($r[0], $false, $true, $false, $false, $false, $true, 1, $false, $r[1], 2)
    }

    # Fix FixIt over-replacement in FixItIt etc - restore FixIt for app name only (skip if needed)

    # --- Replace e-commerce block ---
    $badStart = "Trong một ứng dụng e-commerce"
    $badEnd = "Giao diện…"

    $rng = $doc.Content
    if ($rng.Find.Execute($badStart)) {
        $startRange = $rng.Duplicate
        $endRng = $doc.Content
        if ($endRng.Find.Execute($badEnd)) {
            $replaceRange = $doc.Range($startRange.Start, $endRng.End)
            # Get auth section from ch45 content (from 5.2.1 part only for this slot)
            $authBlock = @"
Giao diện đăng nhập, đăng ký

Module auth cung cấp luồng xác thực hoàn chỉnh trên nền tảng Flutter kết hợp Appwrite. Giao diện đăng nhập (LoginScreen) sử dụng ConsumerStatefulWidget và Riverpod. Form gồm trường email, mật khẩu với validation. Khi người dùng nhấn "Đăng nhập", phương thức _submit() gọi authNotifierProvider.notifier.signIn().

Luồng xử lý đăng nhập:
1. LoginScreen gọi AuthNotifier.signIn(email, password).
2. AuthNotifier gọi AppwriteAuthRepositoryImpl.signInWithEmail().
3. Appwrite Account.createEmailPasswordSession() tạo session JWT.
4. Repository đồng bộ user document trong collection users.
5. currentUserProvider cập nhật, GoRouter redirect về /home.

GoRouter kết hợp auth_redirect.dart kiểm tra onboarding, xác thực email/phone, chọn vai trò và trạng thái duyệt KTV trước khi cho phép truy cập Home. Khác với ứng dụng web PHP/Laravel, FixIt không dùng session server-side hay Hash::check mà dùng JWT session của Appwrite.

Hình 5.1. Giao diện đăng nhập ứng dụng FixIt

Hình 5.2. Luồng xử lý đăng nhập qua Appwrite và Riverpod
"@
            $replaceRange.Text = $authBlock
            Write-Host "Replaced e-commerce block"
        }
    }

    # --- Insert section 2.2 before "Đối tượng và phạm vi nghiên cứu" ---
    $find22 = $doc.Content.Find
    if ($find22.Execute("Đối tượng và phạm vi nghiên cứu")) {
        $insRange = $doc.Range($find22.Parent.Start, $find22.Parent.Start)
        $insRange.InsertBefore("`r`n" + $sec22 + "`r`n`r`n")
        Write-Host "Inserted section 2.2"
    }

    # --- Replace empty Ch4 section: from "Sơ đồ Use case" (first in THIET KE) to before KET LUAN ---
    $findUC = $doc.Content.Find
    $foundUC = $false
    # Find "THIẾT KẾ HỆ THỐNG" then next "Sơ đồ Use case"
    $findTK = $doc.Content.Find
    if ($findTK.Execute("THIẾT KẾ HỆ THỐNG")) {
        $searchFrom = $doc.Range($findTK.Parent.End, $doc.Content.End)
        $findUC2 = $searchFrom.Find
        $findUC2.Text = "Sơ đồ Use case"
        if ($findUC2.Execute()) {
            $startCh4 = $findUC2.Parent.Start
            $findKL = $doc.Content.Find
            $findKL.Text = "KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN"
            if ($findKL.Execute()) {
                $endCh4 = $findKL.Parent.Start
                if ($endCh4 -gt $startCh4) {
                    $ch4Range = $doc.Range($startCh4, $endCh4)
                    $ch4Range.Text = $secCh45 + "`r`n`r`n"
                    Write-Host "Replaced Chapters 4-5 content"
                }
            }
        }
    }

    # --- Replace Danh muc hinh ---
    $findDH = $doc.Content.Find
    if ($findDH.Execute("DANH MỤC HÌNH ẢNH")) {
        $startDH = $findDH.Parent.End
        $findDB = $doc.Content.Find
        $findDB.Text = "DANH MỤC BẢNG BIỂU"
        if ($findDB.Execute()) {
            $endDH = $findDB.Parent.Start
            if ($endDH -gt $startDH) {
                $doc.Range($startDH, $endDH).Text = "`r`n" + ($secHinh -replace "DANH MỤC HÌNH ẢNH`r`n", "") + "`r`n"
                Write-Host "Updated Danh muc hinh"
            }
        }
    }

    # --- Replace Danh muc bang ---
    $findDB2 = $doc.Content.Find
    if ($findDB2.Execute("DANH MỤC BẢNG BIỂU")) {
        $startDB = $findDB2.Parent.End
        $findGT = $doc.Content.Find
        $findGT.Text = "GIỚI THIỆU"
        # Find GIỚI THIỆU in body (not TOC) - use second occurrence
        $count = 0
        $searchRng = $doc.Content
        while ($searchRng.Find.Execute("GIỚI THIỆU")) {
            $count++
            if ($count -ge 2) {
                $endDB = $searchRng.Start
                break
            }
            $searchRng.Start = $searchRng.End
            $searchRng.End = $doc.Content.End
        }
        if ($endDB -gt $startDB) {
            $doc.Range($startDB, $endDB).Text = "`r`n" + ($secBang -replace "DANH MỤC BẢNG BIỂU`r`n", "") + "`r`n"
            Write-Host "Updated Danh muc bang"
        }
    }

    # --- Replace Tai lieu tham khao ---
    $findTL = $doc.Content.Find
    if ($findTL.Execute("TÀI LIỆU THAM KHẢO")) {
        $startTL = $findTL.Parent.Start
        $endTL = $doc.Content.End
        $doc.Range($startTL, $endTL).Text = $secTL
        Write-Host "Updated Tai lieu tham khao"
    }

    # --- Remove duplicate cover page (second "BỘ GIÁO DỤC VÀ ĐÀO TẠO" block) ---
    $find1 = $doc.Content.Find
    $find1.Text = "BỘ GIÁO DỤC VÀ ĐÀO TẠO"
    $occurrences = @()
    $searchAll = $doc.Content
    while ($searchAll.Find.Execute("BỘ GIÁO DỤC VÀ ĐÀO TẠO")) {
        $occurrences += $searchAll.Start
        $searchAll.Start = $searchAll.End + 1
        $searchAll.End = $doc.Content.End
    }
    if ($occurrences.Count -ge 2) {
        # Delete from 2nd occurrence to before "LỜI MỞ ĐẦU" (2nd)
        $startDup = $occurrences[1]
        $findLM = $doc.Range($startDup, $doc.Content.End).Find
        $findLM.Text = "LỜI MỞ ĐẦU"
        if ($findLM.Execute()) {
            $endDup = $findLM.Parent.Start
            if ($endDup -gt $startDup) {
                $doc.Range($startDup, $endDup).Delete()
                Write-Host "Removed duplicate cover page"
            }
        }
    }

    # Update TOC fields
    $doc.Fields.Update()
    foreach ($toc in $doc.TablesOfContents) { $toc.Update() }
    foreach ($toc in $doc.TablesOfFigures) { $toc.Update() }

    $doc.Save()
    $doc.Close()
    Write-Host "SUCCESS: Document updated at $docPath"
}
finally {
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
