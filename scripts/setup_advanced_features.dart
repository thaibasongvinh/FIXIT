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

  print('🛠️ Đang thiết lập cấu trúc cho các tính năng nâng cao...');

  // 1. TẠO COLLECTION COUPONS
  try {
    print('--- Tạo collection: coupons ---');
    await databases.createCollection(
        databaseId: databaseId,
        collectionId: 'coupons',
        name: 'Coupons',
        permissions: ['read("any")', 'write("any")']);
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'code',
        size: 50,
        xrequired: true);
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'type',
        size: 20,
        xrequired: true);
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'value',
        xrequired: true);
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'minOrder',
        xrequired: false,
        xdefault: 0);
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'expiry',
        size: 50,
        xrequired: false);
    await databases.createIntegerAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'usageLimit',
        xrequired: false,
        xdefault: 100);
    await databases.createIntegerAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'usedCount',
        xrequired: false,
        xdefault: 0);
    await databases.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: 'coupons',
        key: 'isActive',
        xrequired: false,
        xdefault: true);
    print('✅ Thành công: coupons');
  } catch (e) {
    print('ℹ️ Bỏ qua coupons (đã tồn tại hoặc lỗi): $e');
  }

  // 2. TẠO COLLECTION AUDIT_LOGS
  try {
    print('\n--- Tạo collection: audit_logs ---');
    await databases.createCollection(
        databaseId: databaseId,
        collectionId: 'audit_logs',
        name: 'Audit Logs',
        permissions: ['read("any")', 'write("any")']);
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'audit_logs',
        key: 'adminName',
        size: 100,
        xrequired: true);
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'audit_logs',
        key: 'action',
        size: 100,
        xrequired: true);
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'audit_logs',
        key: 'target',
        size: 100,
        xrequired: true);
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'audit_logs',
        key: 'createdAt',
        size: 50,
        xrequired: true);
    print('✅ Thành công: audit_logs');
  } catch (e) {
    print('ℹ️ Bỏ qua audit_logs: $e');
  }

  // 3. THÊM CỘT isOnline CHO TECHNICIANS (Nếu chưa có)
  try {
    print('\n--- Cập nhật bảng technicians (thêm trạng thái trực tuyến) ---');
    await databases.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: 'technicians',
        key: 'isOnline',
        xrequired: false,
        xdefault: false);
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'technicians',
        key: 'lat',
        xrequired: false);
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'technicians',
        key: 'lng',
        xrequired: false);
    print('✅ Thành công: isOnline, lat, lng');
  } catch (e) {
    print('ℹ️ Bỏ qua technicians update: $e');
  }

  print('\n🎯 Hoàn tất thiết lập hạ tầng!');
}
