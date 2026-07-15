import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  const String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  const String projectId = '6a145b8d001aa82f4dd5';
  const String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  const String databaseId = 'database-default';

  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('🛠️ Đang bổ sung các trường còn thiếu cho collection bookings...');

  final fields = {
    'customerPhone': 20,
    'technicianPhone': 20,
    'serviceType': 100,
    'deviceInfo': 255,
    'address': 500,
    'paymentStatus': 20,
    'notes': 1000,
    'cancelReason': 1000,
    'updatedAt': 50,
    'scheduledAt': 50,
  };

  for (var entry in fields.entries) {
    try {
      await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'bookings',
        key: entry.key,
        size: entry.value,
        xrequired: false,
      );
      print('✅ Thành công: ${entry.key}');
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      print('ℹ️ ${entry.key}: $e');
    }
  }

  try {
    await databases.createBooleanAttribute(
      databaseId: databaseId,
      collectionId: 'bookings',
      key: 'isReviewed',
      xrequired: false,
      xdefault: false,
    );
    print('✅ Thành công: isReviewed');
    await Future.delayed(const Duration(seconds: 1));
  } catch (e) {
    print('ℹ️ isReviewed: $e');
  }

  try {
    await databases.createIntegerAttribute(
      databaseId: databaseId,
      collectionId: 'bookings',
      key: 'estimatedPrice',
      xrequired: false,
    );
    print('✅ Thành công: estimatedPrice');
    await Future.delayed(const Duration(seconds: 1));
  } catch (e) {
    print('ℹ️ estimatedPrice: $e');
  }

  try {
    await databases.createIntegerAttribute(
      databaseId: databaseId,
      collectionId: 'bookings',
      key: 'finalPrice',
      xrequired: false,
    );
    print('✅ Thành công: finalPrice');
    await Future.delayed(const Duration(seconds: 1));
  } catch (e) {
    print('ℹ️ finalPrice: $e');
  }

  try {
    await databases.createFloatAttribute(
      databaseId: databaseId,
      collectionId: 'bookings',
      key: 'latitude',
      xrequired: false,
    );
    print('✅ Thành công: latitude');
    await Future.delayed(const Duration(seconds: 1));
  } catch (e) {
    print('ℹ️ latitude: $e');
  }

  try {
    await databases.createFloatAttribute(
      databaseId: databaseId,
      collectionId: 'bookings',
      key: 'longitude',
      xrequired: false,
    );
    print('✅ Thành công: longitude');
  } catch (e) {
    print('ℹ️ longitude: $e');
  }

  print('\n🎯 Hoàn tất cập nhật schema cho bookings!');
}
