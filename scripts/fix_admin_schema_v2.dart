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

  final targets = [
    {'col': 'technician_applications', 'key': 'status'},
    {'col': 'bookings', 'key': 'status'},
  ];

  for (var target in targets) {
    try {
      print(
          '🛠️ Đang ép tạo cột "${target['key']}" cho bảng ${target['col']}...');
      await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: target['col']!,
        key: target['key']!,
        size: 50,
        xrequired: false, // Để false cho chắc chắn tạo được
      );
      print('  ✅ Thành công');
    } catch (e) {
      print('  ❌ Lỗi hoặc đã có: $e');
    }
  }
}
