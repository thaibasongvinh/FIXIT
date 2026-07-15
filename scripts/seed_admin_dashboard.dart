import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';

// CẤU HÌNH KẾT NỐI
final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));
final String databaseId =
    Platform.environment['APPWRITE_DATABASE_ID'] ?? 'database-default';

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);

  Databases databases = Databases(client);

  print('🚀 Bắt đầu đẩy dữ liệu mẫu cho Admin Dashboard...');

  try {
    // 1. TẠO HỒ SƠ THỢ MẪU (Technician Applications)
    print('--- Đang tạo hồ sơ thợ chờ duyệt ---');
    final apps = [
      {
        'fullName': 'Nguyễn Văn A',
        'specialty': 'Sửa Điện',
        'experience': '5 năm',
        'status': 'pending',
        'userId': 'user_01'
      },
      {
        'fullName': 'Trần Thị B',
        'specialty': 'Sửa Nước',
        'experience': '3 năm',
        'status': 'pending',
        'userId': 'user_02'
      },
      {
        'fullName': 'Lê Văn C',
        'specialty': 'Máy Lạnh',
        'experience': '10 năm',
        'status': 'pending',
        'userId': 'user_03'
      },
    ];

    for (var app in apps) {
      try {
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: 'technician_applications',
          documentId: ID.unique(),
          data: {...app, 'createdAt': DateTime.now().toIso8601String()},
        );
      } catch (e) {
        print('⚠️ Lỗi khi tạo hồ sơ thợ: $e');
      }
    }

    // 2. TẠO ĐƠN HÀNG MẪU (Bookings) - Để vẽ biểu đồ
    print('--- Đang tạo đơn hàng mẫu (7 ngày qua) ---');
    final now = DateTime.now();
    final services = ['Plumbers', 'Electric work', 'Solar', 'Ac & Ventilation'];

    // Tạo khoảng 15 đơn hàng ngẫu nhiên
    for (int i = 0; i < 15; i++) {
      final daysAgo = i % 7;
      final createdAt = now.subtract(Duration(days: daysAgo, hours: i));
      final status =
          i % 3 == 0 ? 'completed' : (i % 3 == 1 ? 'ongoing' : 'pending');
      final price = (200000 + (i * 50000)).toDouble();

      try {
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: 'bookings',
          documentId: ID.unique(),
          data: {
            'customerName': 'Khách hàng $i',
            'technicianName': 'Thợ ${i % 5}',
            'serviceTitle': services[i % services.length],
            'totalPrice': price,
            'status': status,
            'createdAt': createdAt.toIso8601String(),
          },
        );
      } catch (e) {
        print('⚠️ Lỗi khi tạo đơn hàng: $e');
      }
    }

    print(
        '\n✅ Hoàn tất! Dữ liệu đã được đẩy lên Appwrite. Hãy khởi động lại ứng dụng để xem kết quả trên Dashboard.');
  } catch (e) {
    print('❌ Lỗi hệ thống: $e');
  }
}
