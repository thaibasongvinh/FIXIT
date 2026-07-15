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

  print('🛠️ Đang cập nhật cấu trúc bảng cho Technician Onboarding...');

  // 1. Cập nhật technician_applications
  print('\n--- Cập nhật technician_applications ---');
  final appFields = [
    {'key': 'identityNumber', 'type': 'string', 'size': 20},
    {'key': 'identityCardFront', 'type': 'string', 'size': 500},
    {'key': 'identityCardBack', 'type': 'string', 'size': 500},
    {'key': 'serviceRadius', 'type': 'double'},
    {'key': 'workSchedule', 'type': 'string', 'size': 500},
    {'key': 'verifiedStatus', 'type': 'string', 'size': 20},
    {'key': 'fullName', 'type': 'string', 'size': 100},
    {'key': 'specialty', 'type': 'string', 'size': 500},
    {'key': 'experience', 'type': 'string', 'size': 50},
    {'key': 'paymentMethods', 'type': 'string', 'size': 500, 'array': true},
    {'key': 'latitude', 'type': 'double'},
    {'key': 'longitude', 'type': 'double'},
    {'key': 'startTime', 'type': 'string', 'size': 10},
    {'key': 'endTime', 'type': 'string', 'size': 10},
    {'key': 'hourlyRate', 'type': 'double'},
    {'key': 'businessName', 'type': 'string', 'size': 200},
    {'key': 'businessAddress', 'type': 'string', 'size': 500},
    {'key': 'serviceArea', 'type': 'string', 'size': 1000},
  ];

  for (var field in appFields) {
    try {
      if (field['type'] == 'string') {
        await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: 'technician_applications',
          key: field['key'] as String,
          size: field['size'] as int,
          xrequired: false,
          array: field['array'] as bool? ?? false,
        );
      } else if (field['type'] == 'double') {
        await databases.createFloatAttribute(
          databaseId: databaseId,
          collectionId: 'technician_applications',
          key: field['key'] as String,
          xrequired: false,
        );
      }
      print('✅ Đã thêm: ${field['key']}');
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('ℹ️ ${field['key']}: $e');
    }
  }

  // 2. Cập nhật technicians
  print('\n--- Cập nhật technicians ---');
  final techFields = [
    {'key': 'identityNumber', 'type': 'string', 'size': 20},
    {'key': 'identityCardFront', 'type': 'string', 'size': 500},
    {'key': 'identityCardBack', 'type': 'string', 'size': 500},
    {'key': 'serviceRadius', 'type': 'double'},
    {'key': 'workSchedule', 'type': 'string', 'size': 500},
    {'key': 'verifiedStatus', 'type': 'string', 'size': 20},
    {'key': 'phone', 'type': 'string', 'size': 20},
    {'key': 'pricePerHour', 'type': 'integer'},
  ];

  for (var field in techFields) {
    try {
      if (field['type'] == 'string') {
        await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: 'technicians',
          key: field['key'] as String,
          size: field['size'] as int,
          xrequired: false,
        );
      } else if (field['type'] == 'double') {
        await databases.createFloatAttribute(
          databaseId: databaseId,
          collectionId: 'technicians',
          key: field['key'] as String,
          xrequired: false,
        );
      } else if (field['type'] == 'integer') {
        await databases.createIntegerAttribute(
          databaseId: databaseId,
          collectionId: 'technicians',
          key: field['key'] as String,
          xrequired: false,
        );
      }
      print('✅ Đã thêm: ${field['key']}');
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('ℹ️ ${field['key']}: $e');
    }
  }

  print('\n🎯 Hoàn tất cập nhật DB!');
}
