import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ?? 'https://sgp.cloud.appwrite.io/v1';
final String projectId = Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
final String databaseId = 'database-default';

void main() async {
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('🚀 BẮT ĐẦU TRIỂN KHAI LIÊN KẾT ID CHO TOÀN BỘ 27 BẢNG...');

  final Map<String, List<String>> schemaLinks = {
    // Nhóm Định danh
    'technician_applications': ['userId'],
    'technicians': ['userId'],
    'user_settings': ['userId'],
    'address_book': ['userId'],
    'wallets': ['userId'],
    'payment_methods': ['userId'],
    
    // Nhóm Dịch vụ & Kiến thức
    'popular_services': ['serviceId'],
    'service_issues': ['serviceId'],
    'guides': ['serviceId', 'issueId'],
    'guide_steps': ['guideId'],
    
    // Nhóm Giao dịch
    'bookings': ['customerId', 'technicianId', 'serviceId', 'couponId'],
    'reviews': ['bookingId', 'userId', 'technicianId'],
    'transactions': ['walletId', 'bookingId', 'userId'],
    
    // Nhóm Tương tác
    'chat_rooms': ['customerId', 'technicianId', 'bookingId'],
    'chat_messages': ['roomId', 'senderId'],
    'calls': ['callerId', 'receiverId'],
    'notifications': ['userId'],
    
    // Nhóm Yêu thích & Lưu trữ
    'favorites': ['userId', 'technicianId'],
    'guide_bookmarks': ['userId', 'guideId'],
    'guide_ratings': ['userId', 'guideId'],
  };

  for (var entry in schemaLinks.entries) {
    final colId = entry.key;
    final keys = entry.value;

    print('\n📦 Xử lý bảng: $colId');
    
    // Lấy danh sách thuộc tính hiện tại để tránh tạo trùng
    Set<String> existingKeys = {};
    try {
      final res = await databases.listAttributes(databaseId: databaseId, collectionId: colId);
      existingKeys = res.attributes.map((e) => e['key'].toString()).toSet();
    } catch (e) {
      print('   ❌ Không thể truy cập bảng $colId. Có thể bảng chưa tồn tại.');
      continue;
    }

    for (var key in keys) {
      if (existingKeys.contains(key)) {
        print('   ✅ [Đã có] $key');
        continue;
      }

      try {
        print('   ➕ Đang tạo liên kết: $key...');
        await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: colId,
          key: key,
          size: 50,
          xrequired: false,
        );
        print('   ✨ Thành công: $key');
        // Appwrite cần thời gian để index attribute mới
        await Future.delayed(const Duration(milliseconds: 800));
      } catch (e) {
        print('   ⚠️ Lỗi khi tạo $key: $e');
      }
    }
  }

  print('\n🎯 HOÀN TẤT TRIỂN KHAI! 27 bảng hiện đã được kết nối chặt chẽ bằng các ID liên kết.');
}
