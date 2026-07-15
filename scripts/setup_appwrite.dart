import 'dart:io';
import 'package:dart_appwrite/enums.dart';
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

  print('🛡️ CHẾ ĐỘ CẬP NHẬT AN TOÀN: CHỈ THÊM/CẬP NHẬT 21 BẢNG...');

  final collections = [
    'app_config',
    'banners',
    'bookings',
    'chat_messages',
    'chat_rooms',
    'favorites',
    'guide_bookmarks',
    'guide_ratings',
    'guide_steps',
    'guides',
    'payment_methods',
    'popular_services',
    'products',
    'reviews',
    'service_issues',
    'services',
    'technician_applications',
    'technicians',
    'transactions',
    'users',
    'wallets'
  ];

  for (var colId in collections) {
    try {
      try {
        await databases.getCollection(
            databaseId: databaseId, collectionId: colId);
        print('📦 Bảng $colId đã có.');
      } catch (_) {
        print('✨ Tạo bảng mới: $colId');
        await databases.createCollection(
            databaseId: databaseId,
            collectionId: colId,
            name: colId,
            permissions: [
              Permission.read(Role.any()),
              Permission.write(Role.any())
            ]);
        await Future.delayed(const Duration(seconds: 2));
      }

      final existingCol = await databases.getCollection(
          databaseId: databaseId, collectionId: colId);
      final Set<String> existingKeys = {};
      for (var attr in existingCol.attributes) {
        if (attr is Map) {
          existingKeys.add(attr['key'].toString());
        } else {
          try {
            existingKeys.add((attr as dynamic).key.toString());
          } catch (_) {}
        }
      }

      final targetAttrs = getFullAttributesFor(colId);
      for (var attr in targetAttrs) {
        if (existingKeys.contains(attr['key'])) continue;
        print('  ➕ Thêm cột thiếu: ${attr['key']}');
        await createAttribute(databases, colId, attr);
        await Future.delayed(const Duration(milliseconds: 600));
      }
    } catch (e) {
      print('❌ Lỗi $colId: $e');
    }
  }
}

Future<void> createAttribute(
    Databases db, String colId, Map<String, dynamic> attr) async {
  final key = attr['key'] as String;
  final type = attr['type'] as String;
  final isReq = attr['required'] as bool;
  final isArray = attr['array'] ?? false;
  if (type == 'string') {
    await db.createStringAttribute(
        databaseId: databaseId,
        collectionId: colId,
        key: key,
        size: attr['size'] ?? 255,
        xrequired: isReq,
        array: isArray);
  } else if (type == 'integer') {
    await db.createIntegerAttribute(
        databaseId: databaseId,
        collectionId: colId,
        key: key,
        xrequired: isReq,
        array: isArray);
  } else if (type == 'boolean') {
    await db.createBooleanAttribute(
        databaseId: databaseId,
        collectionId: colId,
        key: key,
        xrequired: isReq,
        xdefault: attr['default']);
  } else if (type == 'double') {
    await db.createFloatAttribute(
        databaseId: databaseId,
        collectionId: colId,
        key: key,
        xrequired: isReq);
  }
}

List<Map<String, dynamic>> getFullAttributesFor(String colId) {
  switch (colId) {
    case 'technicians':
      return [
        {'key': 'name', 'type': 'string', 'required': true},
        {'key': 'avatar', 'type': 'string', 'required': false},
        {'key': 'color', 'type': 'string', 'required': false},
        {'key': 'bio', 'type': 'string', 'required': false, 'size': 1000},
        {'key': 'skills', 'type': 'string', 'required': false, 'array': true},
        {'key': 'rating', 'type': 'double', 'required': false},
        {'key': 'experience', 'type': 'integer', 'required': false},
        {'key': 'completedOrders', 'type': 'integer', 'required': false},
        {
          'key': 'isAvailable',
          'type': 'boolean',
          'required': true,
          'default': true
        },
        {'key': 'reviewCount', 'type': 'integer', 'required': false},
        {
          'key': 'portfolioImages',
          'type': 'string',
          'required': false,
          'array': true
        },
      ];
    case 'service_issues':
      return [
        {'key': 'serviceId', 'type': 'string', 'required': true},
        {'key': 'title', 'type': 'string', 'required': true},
        {
          'key': 'description',
          'type': 'string',
          'required': false,
          'size': 1000
        },
        {'key': 'imagePath', 'type': 'string', 'required': false},
      ];
    case 'products':
      return [
        {'key': 'name', 'type': 'string', 'required': true},
        {'key': 'price', 'type': 'integer', 'required': true},
        {'key': 'imagePath', 'type': 'string', 'required': true},
        {
          'key': 'description',
          'type': 'string',
          'required': false,
          'size': 1000
        },
        {
          'key': 'relatedIssueIds',
          'type': 'string',
          'required': false,
          'array': true
        },
      ];
    case 'guides':
      return [
        {'key': 'issueId', 'type': 'string', 'required': true},
        {'key': 'title', 'type': 'string', 'required': true},
        {'key': 'videoUrl', 'type': 'string', 'required': false},
      ];
    case 'guide_steps':
      return [
        {'key': 'guideId', 'type': 'string', 'required': true},
        {'key': 'stepNumber', 'type': 'integer', 'required': true},
        {'key': 'content', 'type': 'string', 'required': true, 'size': 2000},
      ];
    default:
      return [];
  }
}
