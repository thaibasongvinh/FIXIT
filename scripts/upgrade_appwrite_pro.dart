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

  print('🚀 Đang nâng cấp Appwrite cho luồng Thợ chuyên nghiệp...');

  // 1. Cập nhật technicians và technician_applications
  final collectionsToUpdate = ['technicians', 'technician_applications'];
  for (var collId in collectionsToUpdate) {
    print('\n--- Cập nhật attributes cho: $collId ---');
    try {
      await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: 'identityNumber',
          size: 20,
          xrequired: false);
      await Future.delayed(Duration(seconds: 1));
      await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: 'identityCardFront',
          size: 500,
          xrequired: false);
      await Future.delayed(Duration(seconds: 1));
      await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: 'identityCardBack',
          size: 500,
          xrequired: false);
      await Future.delayed(Duration(seconds: 1));
      await databases.createFloatAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: 'serviceRadius',
          xrequired: false,
          xdefault: 10.0);
      await Future.delayed(Duration(seconds: 1));
      await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: 'workSchedule',
          size: 1000,
          xrequired: false);
      await Future.delayed(Duration(seconds: 1));
      await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: 'verifiedStatus',
          size: 20,
          xrequired: false,
          xdefault: 'unverified');
      print('✅ Thành công: $collId');
    } catch (e) {
      print('ℹ️ Bỏ qua hoặc lỗi tại $collId update: $e');
    }
  }

  // 2. Cập nhật bookings
  try {
    print('\n--- Cập nhật bookings (thêm ID liên kết) ---');
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'bookings',
        key: 'customerId',
        size: 50,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'bookings',
        key: 'technicianId',
        size: 50,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'bookings',
        key: 'serviceId',
        size: 50,
        xrequired: false);
    print('✅ Thành công: bookings');
  } catch (e) {
    print('ℹ️ Bỏ qua bookings update: $e');
  }

  // 3. Cập nhật wallets
  try {
    print('\n--- Cập nhật wallets ---');
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'wallets',
        key: 'userId',
        size: 50,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'wallets',
        key: 'balance',
        xrequired: false,
        xdefault: 0.0);
    await Future.delayed(Duration(seconds: 1));
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'wallets',
        key: 'totalEarned',
        xrequired: false,
        xdefault: 0.0);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'wallets',
        key: 'bankAccount',
        size: 1000,
        xrequired: false);
    print('✅ Thành công: wallets');
  } catch (e) {
    print('ℹ️ Bỏ qua wallets: $e');
  }

  // 4. Tạo collection notifications
  try {
    print('\n--- Tạo collection: notifications ---');
    await databases.createCollection(
        databaseId: databaseId,
        collectionId: 'notifications',
        name: 'Notifications',
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any())
        ]);
    await Future.delayed(Duration(seconds: 2));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'userId',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'title',
        size: 200,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'body',
        size: 1000,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'type',
        size: 50,
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'isRead',
        xrequired: false,
        xdefault: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'notifications',
        key: 'createdAt',
        size: 50,
        xrequired: false);
    print('✅ Thành công: notifications');
  } catch (e) {
    print('ℹ️ Bỏ qua notifications: $e');
  }

  // 5. Tạo collection address_book
  try {
    print('\n--- Tạo collection: address_book ---');
    await databases.createCollection(
        databaseId: databaseId,
        collectionId: 'address_book',
        name: 'Address Book',
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any())
        ]);
    await Future.delayed(Duration(seconds: 2));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'address_book',
        key: 'userId',
        size: 50,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'address_book',
        key: 'addressLine',
        size: 500,
        xrequired: true);
    await Future.delayed(Duration(seconds: 1));
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'address_book',
        key: 'lat',
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: 'address_book',
        key: 'lng',
        xrequired: false);
    await Future.delayed(Duration(seconds: 1));
    await databases.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: 'address_book',
        key: 'isDefault',
        xrequired: false,
        xdefault: false);
    print('✅ Thành công: address_book');
  } catch (e) {
    print('ℹ️ Bỏ qua address_book: $e');
  }

  print('\n🎯 Hoàn tất nâng cấp hạ tầng Appwrite!');
}
