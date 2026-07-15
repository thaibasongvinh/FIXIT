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
  Storage storage = Storage(client);

  print('🛡️ Bắt đầu siết chặt bảo mật cho hệ thống FixIt...');

  // 1. Cấu hình quyền hạn cho các bảng nhạy cảm
  // Quy tắc: Không cho phép "any" (khách) đọc dữ liệu cá nhân
  final secureCollections = {
    'users': [Permission.read(Role.users()), Permission.update(Role.users())],
    'wallets': [Permission.read(Role.users())],
    'transactions': [Permission.read(Role.users())],
    'technician_applications': [
      Permission.read(Role.users()),
      Permission.create(Role.users())
    ],
    'notifications': [
      Permission.read(Role.users()),
      Permission.update(Role.users())
    ],
    'chat_rooms': [
      Permission.read(Role.users()),
      Permission.write(Role.users())
    ],
    'chat_messages': [
      Permission.read(Role.users()),
      Permission.create(Role.users())
    ],
    'calls': [Permission.read(Role.users()), Permission.write(Role.users())],
  };

  for (var entry in secureCollections.entries) {
    try {
      print('🔒 Đang bảo mật bảng: ${entry.key}...');
      await databases.updateCollection(
        databaseId: databaseId,
        collectionId: entry.key,
        name: entry.key,
        permissions: entry.value,
        documentSecurity:
            true, // Kích hoạt bảo mật cấp tài liệu (Document Level Security)
      );
      print('    ✅ Thành công');
    } catch (e) {
      print('    ❌ Lỗi: $e');
    }
  }

  // 2. Siết chặt Storage Buckets
  final secureBuckets = [
    'fixit_assets',
    'technician_documents',
    'chats', // Bucket cho ảnh chat
  ];

  for (var bucketId in secureBuckets) {
    try {
      print('📂 Đang bảo mật Bucket: $bucketId...');
      await storage.updateBucket(
        bucketId: bucketId,
        name: bucketId,
        permissions: [
          Permission.read(Role.users()),
          Permission.write(Role.users()),
        ],
        fileSecurity: true, // Chỉ người có quyền mới xem được file cụ thể
      );
      print('    ✅ Thành công');
    } catch (e) {
      print('    ❌ Lỗi: $e');
    }
  }

  print('\n🎯 Hoàn tất siết chặt bảo mật!');
  print(
      'Lưu ý: Document Level Security (DLS) đã được bật. Chỉ những người được gán quyền trong document mới có thể truy cập.');
}
