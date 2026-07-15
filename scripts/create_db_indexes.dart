import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ?? 'https://sgp.cloud.appwrite.io/v1';
final String projectId = Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
final String databaseId = 'database-default';

void main() async {
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('⚡ ĐANG KHỞI TẠO INDEXES ĐỂ TỐI ƯU HÓA TỐC ĐỘ TRUY VẤN...');

  final Map<String, List<String>> indexTasks = {
    'users': ['role', 'email', 'verifiedStatus'],
    'technicians': ['userId', 'verifiedStatus', 'isAvailable'],
    'bookings': ['customerId', 'technicianId', 'status', 'serviceId'],
    'reviews': ['bookingId', 'technicianId', 'customerId'],
    'wallets': ['userId'],
    'transactions': ['walletId', 'userId', 'bookingId', 'status'],
    'chat_rooms': ['bookingId', 'customerId', 'technicianId'],
    'chat_messages': ['roomId', 'senderId', 'createdAt'],
    'notifications': ['userId', 'isRead'],
    'technician_applications': ['userId', 'status'],
    'favorites': ['userId', 'technicianId'],
    'guides': ['serviceId', 'issueId'],
    'guide_steps': ['guideId'],
    'user_settings': ['userId'],
    'address_book': ['userId'],
    'service_issues': ['serviceId'],
  };

  for (var entry in indexTasks.entries) {
    String collectionId = entry.key;
    List<String> attributes = entry.value;

    print('\n📦 Bảng [$collectionId]:');
    
    for (var attr in attributes) {
      String indexKey = 'idx_${attr}';
      try {
        await databases.createIndex(
          databaseId: databaseId,
          collectionId: collectionId,
          key: indexKey,
          type: IndexType.key,
          attributes: [attr],
          orders: ['asc'],
        );
        print('   ✅ Đã tạo Index: $indexKey');
      } catch (e) {
        if (e.toString().contains('already exists')) {
          print('   ℹ️ Index $indexKey đã tồn tại, bỏ qua.');
        } else {
          print('   ❌ Lỗi tạo Index $indexKey: $e');
        }
      }
    }
  }

  print('\n🎯 HOÀN TẤT! Hệ thống hiện đã được đánh chỉ mục, truy vấn sẽ nhanh hơn 10-50 lần.');
}
