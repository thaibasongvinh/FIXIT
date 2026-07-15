import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Storage storage = Storage(client);

  print('🚀 Đang cập nhật quyền hạn cho các Bucket của Storage...');

  final buckets = ['fixit_assets', 'technician_documents', 'guide_assets'];

  for (var bucketId in buckets) {
    try {
      print('🛠️ Cập nhật Bucket: $bucketId...');
      await storage.updateBucket(
        bucketId: bucketId,
        name: bucketId,
        permissions: [
          'read("any")',
          'write("any")',
          'create("any")',
          'update("any")',
          'delete("any")',
          'read("users")',
          'write("users")',
          'create("users")',
          'update("users")',
          'delete("users")',
        ],
        fileSecurity: true, // Cho phép quyền ở cấp độ file
      );
      print('    ✅ Thành công');
    } catch (e) {
      print('    ❌ Lỗi tại Bucket $bucketId: $e');
    }
  }

  print('\n🎯 Hoàn tất! Bây giờ ứng dụng Admin có thể quản lý file trực tiếp.');
}
