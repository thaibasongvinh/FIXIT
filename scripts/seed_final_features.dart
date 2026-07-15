import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

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

  print('🚀 Đang đẩy dữ liệu cho Broadcast History và Quản lý quyền hạn...');

  // 1. TẠO THÔNG BÁO LỊCH SỬ (Broadcast History)
  try {
    print('--- Đang tạo Lịch sử thông báo mẫu ---');
    final notifications = [
      {
        'title': 'Chào mừng thợ mới',
        'message': 'Hệ thống vừa cập nhật chính sách hoa hồng mới cho thợ.',
        'targetRole': 'technician',
        'type': 'broadcast'
      },
      {
        'title': 'Khuyến mãi hè',
        'message': 'Giảm giá 20% cho tất cả dịch vụ sửa máy lạnh.',
        'targetRole': 'customer',
        'type': 'broadcast'
      },
      {
        'title': 'Bảo trì hệ thống',
        'message': 'Hệ thống sẽ bảo trì từ 12h đêm nay đến 2h sáng mai.',
        'targetRole': 'all',
        'type': 'broadcast'
      },
    ];

    for (var n in notifications) {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: 'notifications',
        documentId: ID.unique(),
        data: {
          ...n,
          'createdAt':
              DateTime.now().subtract(const Duration(days: 2)).toIso8601String()
        },
      );
    }
    print('✅ Tạo Notifications thành công');
  } catch (e) {
    print('⚠️ Lỗi Notifications: $e');
  }

  // 2. CẬP NHẬT QUYỀN HẠN TRONG USERS (Roles)
  try {
    print('--- Đang cập nhật thêm Sub-Admins mẫu ---');
    // Tìm các users chưa có role admin hoặc customer để gán làm sub-admin
    final users = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: 'users',
        queries: [Query.limit(5)]);

    final roles = ['moderator', 'finance_manager', 'support_staff'];

    for (int i = 0; i < users.documents.length; i++) {
      if (i < roles.length) {
        await databases.updateDocument(
            databaseId: databaseId,
            collectionId: 'users',
            documentId: users.documents[i].$id,
            data: {'role': roles[i]});
      }
    }
    print('✅ Cập nhật quyền hạn thành công');
  } catch (e) {
    print('⚠️ Lỗi Roles Update: $e');
  }

  print(
      '\n🎯 Đã sẵn sàng dữ liệu cho các màn hình Báo cáo, Thông báo và Quyền hạn!');
}
