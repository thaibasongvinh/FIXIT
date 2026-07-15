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

  print('🚀 Đang ép buộc cập nhật cấu trúc bảng cho Technician Onboarding...');

  final fieldsToAdd = [
    {
      'col': 'technician_applications',
      'key': 'businessName',
      'type': 'string',
      'size': 255
    },
    {
      'col': 'technician_applications',
      'key': 'businessAddress',
      'type': 'string',
      'size': 500
    },
    {
      'col': 'technician_applications',
      'key': 'serviceRadius',
      'type': 'double'
    },
    {
      'col': 'technician_applications',
      'key': 'workSchedule',
      'type': 'string',
      'size': 500
    },
    {
      'col': 'technicians',
      'key': 'businessName',
      'type': 'string',
      'size': 255
    },
    {
      'col': 'technicians',
      'key': 'businessAddress',
      'type': 'string',
      'size': 500
    },
    {'col': 'technicians', 'key': 'serviceRadius', 'type': 'double'},
    {
      'col': 'technicians',
      'key': 'workSchedule',
      'type': 'string',
      'size': 500
    },
  ];

  for (var field in fieldsToAdd) {
    try {
      print('🛠️ Đang xử lý: ${field['col']} -> ${field['key']}');
      if (field['type'] == 'string') {
        await databases.createStringAttribute(
          databaseId: databaseId,
          collectionId: field['col'] as String,
          key: field['key'] as String,
          size: field['size'] as int,
          xrequired: false,
        );
      } else if (field['type'] == 'double') {
        await databases.createFloatAttribute(
          databaseId: databaseId,
          collectionId: field['col'] as String,
          key: field['key'] as String,
          xrequired: false,
        );
      }
      print('✅ Đã thêm thành công: ${field['key']}');
    } catch (e) {
      print('ℹ️ Bỏ qua ${field['key']}: $e');
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  print('\n🎯 Hoàn tất cập nhật ép buộc!');
}
