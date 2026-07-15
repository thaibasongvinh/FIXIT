import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ??
    'https://sgp.cloud.appwrite.io/v1';
final String projectId =
    Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ??
    (throw StateError('APPWRITE_API_KEY is required'));
const String bucketId = 'technician_documents';

void main() async {
  Client client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Storage storage = Storage(client);

  print('📦 Đang thiết lập kho lưu trữ (Bucket) cho thợ...');

  try {
    await storage.getBucket(bucketId: bucketId);
    print('✅ Kho lưu trữ "$bucketId" đã tồn tại.');
  } catch (e) {
    print('✨ Đang tạo kho lưu trữ mới: $bucketId');
    try {
      await storage.createBucket(
        bucketId: bucketId,
        name: 'Technician Documents',
        permissions: [
          Permission.read(Role.any()),
          Permission.create(Role.users()),
          Permission.update(Role.users()),
          Permission.delete(Role.users()),
        ],
        fileSecurity: true,
      );
      print('✅ Đã tạo thành công kho lưu trữ "$bucketId"!');
    } catch (createError) {
      print('❌ Lỗi khi tạo kho lưu trữ: $createError');
    }
  }

  print('\n🎯 Hoàn tất thiết lập Storage!');
}
