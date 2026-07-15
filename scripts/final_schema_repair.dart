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

  print('🚀 Đang thực hiện sửa lỗi Database toàn diện...');

  final collections = ['technician_applications', 'technicians'];
  final attributes = [
    {'key': 'userId', 'type': 'string', 'size': 50},
    {'key': 'fullName', 'type': 'string', 'size': 255},
    {'key': 'specialty', 'type': 'string', 'size': 500},
    {'key': 'experience', 'type': 'string', 'size': 100},
    {'key': 'businessName', 'type': 'string', 'size': 255},
    {'key': 'businessAddress', 'type': 'string', 'size': 500},
    {'key': 'serviceArea', 'type': 'string', 'size': 1000},
    {'key': 'startTime', 'type': 'string', 'size': 10},
    {'key': 'endTime', 'type': 'string', 'size': 10},
    {'key': 'hourlyRate', 'type': 'double'},
    {'key': 'flatFee', 'type': 'double'},
    {'key': 'additionalInfo', 'type': 'string', 'size': 2000},
    {'key': 'documents', 'type': 'string', 'size': 500, 'array': true},
    {'key': 'status', 'type': 'string', 'size': 20},
    {'key': 'identityNumber', 'type': 'string', 'size': 20},
    {'key': 'identityCardFront', 'type': 'string', 'size': 500},
    {'key': 'identityCardBack', 'type': 'string', 'size': 500},
    {'key': 'serviceRadius', 'type': 'double'},
    {'key': 'workSchedule', 'type': 'string', 'size': 500},
    {'key': 'verifiedStatus', 'type': 'string', 'size': 20},
    {'key': 'createdAt', 'type': 'string', 'size': 50},
    {'key': 'updatedAt', 'type': 'string', 'size': 50},
  ];

  for (var colId in collections) {
    print('\n📦 Đang xử lý bảng: $colId');
    for (var attr in attributes) {
      try {
        final key = attr['key'] as String;
        final type = attr['type'] as String;
        final isArray = attr['array'] == true;

        if (type == 'string') {
          await databases.createStringAttribute(
            databaseId: databaseId,
            collectionId: colId,
            key: key,
            size: attr['size'] as int,
            xrequired: false,
            array: isArray,
          );
        } else if (type == 'double') {
          await databases.createFloatAttribute(
            databaseId: databaseId,
            collectionId: colId,
            key: key,
            xrequired: false,
          );
        }
        print('✅ Đã thêm: $key');
      } catch (e) {
        if (e.toString().contains('409')) {
          // print('ℹ️ Bỏ qua (đã có): ${attr['key']}');
        } else {
          print('❌ Lỗi ${attr['key']}: $e');
        }
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  print('\n🎯 Đã hoàn tất sửa lỗi Database!');
}
