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

  print('🛠️ Đang bổ sung TOÀN BỘ các cột thiếu cho Admin Dashboard...');

  // --- technician_applications ---
  final techAppAttrs = [
    {'key': 'fullName', 'type': 'string', 'size': 100},
    {'key': 'specialty', 'type': 'string', 'size': 100},
    {'key': 'experience', 'type': 'string', 'size': 50},
    {'key': 'userId', 'type': 'string', 'size': 50},
  ];

  for (var attr in techAppAttrs) {
    try {
      print('  - Thêm ${attr['key']} vào technician_applications...');
      await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'technician_applications',
        key: attr['key'] as String,
        size: attr['size'] as int,
        xrequired: false,
      );
      print('    ✅ Thành công');
    } catch (e) {
      print('    ℹ️ Bỏ qua: $e');
    }
  }

  // --- bookings ---
  final bookingAttrs = [
    {'key': 'customerName', 'type': 'string', 'size': 100},
    {'key': 'technicianName', 'type': 'string', 'size': 100},
    {'key': 'serviceTitle', 'type': 'string', 'size': 100},
  ];

  for (var attr in bookingAttrs) {
    try {
      print('  - Thêm ${attr['key']} vào bookings...');
      await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'bookings',
        key: attr['key'] as String,
        size: attr['size'] as int,
        xrequired: false,
      );
      print('    ✅ Thành công');
    } catch (e) {
      print('    ℹ️ Bỏ qua: $e');
    }
  }

  print('\n🎯 Hoàn tất cập nhật cấu trúc Database.');
}
