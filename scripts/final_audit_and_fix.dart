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

  print('🔍 Đang kiểm tra sao kê toàn bộ cấu trúc liên kết Database...');

  final Map<String, List<Map<String, dynamic>>> expectedSchema = {
    'technician_applications': [
      {'key': 'userId', 'type': 'string', 'size': 50},
      {'key': 'fullName', 'type': 'string', 'size': 255},
      {'key': 'businessName', 'type': 'string', 'size': 255},
      {'key': 'businessAddress', 'type': 'string', 'size': 500},
      {'key': 'specialty', 'type': 'string', 'size': 500},
      {'key': 'status', 'type': 'string', 'size': 20},
    ],
    'technicians': [
      {
        'key': 'userId',
        'type': 'string',
        'size': 50
      }, // Chìa khóa liên kết cực kỳ quan trọng
      {'key': 'name', 'type': 'string', 'size': 255},
      {'key': 'email', 'type': 'string', 'size': 255},
      {'key': 'phone', 'type': 'string', 'size': 20},
      {'key': 'specialty', 'type': 'string', 'size': 255},
      {'key': 'isAvailable', 'type': 'boolean'},
      {'key': 'businessName', 'type': 'string', 'size': 255},
      {'key': 'businessAddress', 'type': 'string', 'size': 500},
    ],
    'users': [
      {'key': 'role', 'type': 'string', 'size': 20},
      {'key': 'skills', 'type': 'string', 'size': 255, 'array': true},
    ]
  };

  for (var colId in expectedSchema.keys) {
    print('\n--- Kiểm tra bảng: $colId ---');
    try {
      final existingAttrs = await databases.listAttributes(
          databaseId: databaseId, collectionId: colId);
      final Set<String> currentKeys =
          existingAttrs.attributes.map((e) => e['key'].toString()).toSet();

      for (var attr in expectedSchema[colId]!) {
        final key = attr['key'] as String;
        if (currentKeys.contains(key)) {
          print('✅ [OK] Trường "$key" đã tồn tại.');
        } else {
          print('🚨 [MISSING] Đang bổ sung trường: "$key"...');
          await createAttribute(databases, colId, attr);
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      print('❌ Lỗi khi kiểm tra bảng $colId: $e');
    }
  }

  print('\n🎯 HOÀN TẤT SAO KÊ: Hệ thống đã sẵn sàng và liên kết chặt chẽ!');
}

Future<void> createAttribute(
    Databases databases, String colId, Map<String, dynamic> attr) async {
  final key = attr['key'] as String;
  final type = attr['type'] as String;
  final isArray = attr['array'] == true;

  try {
    if (type == 'string') {
      await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: colId,
        key: key,
        size: attr['size'] as int,
        xrequired: false,
        array: isArray,
      );
    } else if (type == 'boolean') {
      await databases.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: colId,
        key: key,
        xrequired: false,
        xdefault: false,
      );
    } else if (type == 'double') {
      await databases.createFloatAttribute(
        databaseId: databaseId,
        collectionId: colId,
        key: key,
        xrequired: false,
      );
    }
    print('   ✨ Đã tạo thành công: $key');
  } catch (e) {
    print('   ⚠️ Không thể tạo $key: $e');
  }
}
