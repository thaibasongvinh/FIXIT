# Kế hoạch đồng bộ giao diện Đăng ký (Premium Glassmorphism)

Mục tiêu là nâng cấp màn hình Đăng ký để có giao diện cao cấp, cân đối và chống bóp méo khi hiện bàn phím, tương tự như màn hình Đăng nhập đã thực hiện.

## Các thay đổi chính

### 1. [MODIFY] [register_screen.dart](file:///D:/Documents/MOBILEAPP/FLUTTER/FIXIT/lib/features/auth/presentation/screens/register/register_screen.dart)

*   **Cấu trúc Layout chống bóp méo**:
    *   Sử dụng `LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox`.
    *   Tự động điều chỉnh khoảng cách khi bàn phím mở/đóng (`MediaQuery.of(context).viewInsets.bottom`).
*   **Đồng bộ Header**:
    *   Sử dụng `AuthTopActions` tích hợp sẵn nút Quay lại, Theme (☀️/🌙) và Quốc kỳ (🇻🇳/🇺🇸).
*   **Nâng cấp Glassmorphism**:
    *   Tăng độ nhòe (Blur) từ 15 lên **30**.
    *   Sử dụng viền trắng mờ sắc nét (`width: 0.8`).
*   **Tinh chỉnh Logo & Văn bản**:
    *   Thu nhỏ Logo xuống 100px.
    *   Cập nhật cỡ chữ tiêu đề (28px) và subtitle (14px) cho thanh thoát.
*   **Làm mới Nút Social & Checkbox**:
    *   Áp dụng hiệu ứng kính mờ cho các nút Google/Facebook.
    *   Tinh chỉnh màu sắc và khoảng cách cho phần "Tôi đồng ý với Điều khoản".

## Kế hoạch thực hiện

1.  **Cập nhật cấu trúc Layout**: Chuyển sang mô hình chống bóp méo ổn định.
2.  **Áp dụng phong cách Premium**: Cập nhật Blur, viền và màu sắc của Card.
3.  **Đồng bộ Header & Logo**: Thay thế hàng header cũ và tinh chỉnh kích thước logo.
4.  **Hoàn thiện chi tiết**: Cập nhật Social Buttons và các khoảng trống (`Spacer/Gap`).

## Verification Plan

### Manual Verification
*   Mở màn hình Đăng ký, xác nhận Header và phong cách đồng bộ với Đăng nhập.
*   Bật bàn phím: Xác nhận nội dung không bị nén lùn, có thể cuộn mượt mà.
*   Xác nhận checkbox và link Điều khoản hoạt động đúng.
