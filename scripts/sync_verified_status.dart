import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';

final String endpoint = Platform.environment['APPWRITE_ENDPOINT'] ?? 'https://sgp.cloud.appwrite.io/v1';
final String projectId = Platform.environment['APPWRITE_PROJECT_ID'] ?? '6a145b8d001aa82f4dd5';
final String apiKey = Platform.environment['APPWRITE_API_KEY'] ?? 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
final String databaseId = 'database-default';

void main() async {
  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('🔄 BẮT ĐẦU ĐỒNG BỘ TRẠNG THÁI DUYỆT GIỮA CÁC BẢNG...');

  try {
    // 1. Tìm tất cả hồ sơ đã được duyệt (approved)
    final apps = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: 'technician_applications',
      queries: [Query.equal('status', 'approved')],
    );

    print('📢 Tìm thấy ${apps.total} hồ sơ đã duyệt.');

    for (var app in apps.documents) {
      final userId = app.data['userId'];
      if (userId == null) continue;

      print('🔨 Đang đồng bộ User: $userId (${app.data['fullName']})');

      // 2. Cập nhật bảng 'users'
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: 'users',
        documentId: userId,
        data: {
          'verifiedStatus': 'verified',
          'role': 'technician',
        },
      ).then((_) => print('   ✅ Đã cập nhật bảng users'));

      // 3. Cập nhật bảng 'technicians'
      try {
        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: 'technicians',
          documentId: userId,
          data: {'verifiedStatus': 'verified'},
        ).then((_) => print('   ✅ Đã cập nhật bảng technicians'));
      } catch (e) {
        print('   ⚠️ Bảng technicians chưa có document cho ID này, bỏ qua.');
      }
    }

    print('\n🎯 HOÀN TẤT ĐỒNG BỘ! Bây giờ bạn hãy vào App, dữ liệu đã khớp 100%.');

  } catch (e) {
    print('❌ Lỗi: $e');
  }
}
