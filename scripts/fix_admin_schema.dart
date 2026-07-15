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

  print('🛠️ Đang bổ sung các cột thiếu cho Admin Dashboard...');

  // 1. Thêm cột 'status' cho bảng technician_applications
  try {
    print('  - Thêm cột "status" vào technician_applications...');
    await databases.createStringAttribute(
      databaseId: databaseId,
      collectionId: 'technician_applications',
      key: 'status',
      size: 20,
      xrequired: true,
      xdefault: 'pending',
    );
    print('    ✅ Thành công');
  } catch (e) {
    print('    ℹ️ Bỏ qua (có thể đã tồn tại): $e');
  }

  // 2. Thêm cột 'status' cho bảng bookings
  try {
    print('  - Thêm cột "status" vào bookings...');
    await databases.createStringAttribute(
      databaseId: databaseId,
      collectionId: 'bookings',
      key: 'status',
      size: 20,
      xrequired: true,
      xdefault: 'pending',
    );
    print('    ✅ Thành công');
  } catch (e) {
    print('    ℹ️ Bỏ qua (có thể đã tồn tại): $e');
  }

  // 3. Thêm cột 'totalPrice' cho bảng bookings (để tính doanh thu)
  try {
    print('  - Thêm cột "totalPrice" vào bookings...');
    await databases.createFloatAttribute(
      databaseId: databaseId,
      collectionId: 'bookings',
      key: 'totalPrice',
      xrequired: false,
    );
    print('    ✅ Thành công');
  } catch (e) {
    print('    ℹ️ Bỏ qua (có thể đã tồn tại): $e');
  }

  print('\n🎯 Hoàn tất cập nhật cấu trúc Database. Hãy thử tải lại Dashboard!');
}
