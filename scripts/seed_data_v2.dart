import 'dart:io';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart' as models;

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

  print('🚀 ĐỒNG BỘ CẤU TRÚC DB 100%...');

  // 1. Cập nhật Schema cho các bảng còn thiếu
  await ensureTransactionsSchema(databases);
  await ensureAppConfigSchema(databases);
  await ensureGuideStepsSchema(databases);
  await ensureNotificationsSchema(databases);
  await ensureProductsSchema(databases);
  await ensureUserSettingsSchema(databases);

  print('\n⏳ Chờ 10 giây để Appwrite đồng bộ cấu trúc...');
  await Future.delayed(const Duration(seconds: 10));

  // 2. Nạp dữ liệu mẫu
  await seedTransactions(databases);
  await seedAppConfig(databases);

  print('\n✨ HOÀN TẤT ĐỒNG BỘ 100%!');
}

Future<void> ensureTransactionsSchema(Databases db) async {
  print('\n🛠️ Schema: Transactions...');
  final attrs = [
    {'key': 'walletId', 'type': 'string', 'size': 50},
    {'key': 'amount', 'type': 'integer'},
    {'key': 'type', 'type': 'string', 'size': 20},
    {'key': 'status', 'type': 'string', 'size': 20},
    {'key': 'description', 'type': 'string', 'size': 500},
    {'key': 'createdAt', 'type': 'string', 'size': 50},
  ];
  for (var a in attrs) await _createAttr(db, 'transactions', a);
}

Future<void> ensureAppConfigSchema(Databases db) async {
  print('\n🛠️ Schema: App Config...');
  final attrs = [
    {'key': 'supportPhone', 'type': 'string', 'size': 20},
    {'key': 'supportEmail', 'type': 'string', 'size': 50},
    {'key': 'commissionRate', 'type': 'double'},
    {'key': 'isMaintenance', 'type': 'boolean', 'default': false},
    {'key': 'minVersion', 'type': 'string', 'size': 10},
    {'key': 'maintenanceMessage', 'type': 'string', 'size': 500},
    {'key': 'minWithdrawal', 'type': 'integer'},
    {'key': 'defaultLanguage', 'type': 'string', 'size': 5, 'default': 'vi'},
    {'key': 'defaultTheme', 'type': 'string', 'size': 10, 'default': 'system'},
  ];
  for (var a in attrs) await _createAttr(db, 'app_config', a);
}

Future<void> ensureGuideStepsSchema(Databases db) async {
  print('\n🛠️ Schema: Guide Steps...');
  final attrs = [
    {'key': 'warningNote', 'type': 'string', 'size': 500},
  ];
  for (var a in attrs) await _createAttr(db, 'guide_steps', a);
}

Future<void> ensureNotificationsSchema(Databases db) async {
  print('\n🛠️ Schema: Notifications...');
  try {
    await db.createCollection(
        databaseId: databaseId,
        collectionId: 'notifications',
        name: 'Notifications',
        permissions: [
          Permission.read(Role.any()),
          Permission.write(Role.any())
        ]);
  } catch (_) {}

  final attrs = [
    {'key': 'title', 'type': 'string', 'size': 100},
    {'key': 'message', 'type': 'string', 'size': 1000},
    {'key': 'targetRole', 'type': 'string', 'size': 20},
    {'key': 'type', 'type': 'string', 'size': 20},
    {'key': 'createdAt', 'type': 'string', 'size': 50},
  ];
  for (var a in attrs) await _createAttr(db, 'notifications', a);
}

Future<void> ensureProductsSchema(Databases db) async {
  print('\n🛠️ Schema: Products...');
  final attrs = [
    {'key': 'stock', 'type': 'integer'},
  ];
  for (var a in attrs) await _createAttr(db, 'products', a);
}

Future<void> ensureUserSettingsSchema(Databases db) async {
  print('\n🛠️ Schema: User Settings...');
  try {
    await db.createCollection(
      databaseId: databaseId,
      collectionId: 'user_settings',
      name: 'User Settings',
      permissions: [
        Permission.read(Role.users()),
        Permission.write(Role.users())
      ],
    );
  } catch (_) {}

  final attrs = [
    {'key': 'userId', 'type': 'string', 'size': 50},
    {'key': 'themeMode', 'type': 'string', 'size': 10, 'default': 'system'},
    {'key': 'language', 'type': 'string', 'size': 5, 'default': 'vi'},
  ];
  for (var a in attrs) await _createAttr(db, 'user_settings', a);
}

Future<void> _createAttr(
    Databases db, String collId, Map<String, dynamic> attr) async {
  try {
    final key = attr['key'] as String;
    if (attr['type'] == 'string') {
      await db.createStringAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: key,
          size: attr['size'] as int,
          xrequired: false);
    } else if (attr['type'] == 'integer') {
      await db.createIntegerAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: key,
          xrequired: false);
    } else if (attr['type'] == 'double') {
      await db.createFloatAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: key,
          xrequired: false);
    } else if (attr['type'] == 'boolean') {
      await db.createBooleanAttribute(
          databaseId: databaseId,
          collectionId: collId,
          key: key,
          xrequired: false,
          xdefault: attr['default'] as bool);
    }
    print('  ✅ OK: $key');
  } catch (_) {}
}

Future<void> seedTransactions(Databases db) async {
  print('\n📦 Seeding Transactions...');
  final samples = [
    {
      'walletId': 'sys',
      'amount': 450000,
      'type': 'payment',
      'status': 'success',
      'description': 'Sửa máy lạnh #BK882',
      'createdAt': DateTime.now().toIso8601String()
    },
    {
      'walletId': 'tech1',
      'amount': 250000,
      'type': 'refund',
      'status': 'pending',
      'description': 'Rút tiền - Thợ Minh',
      'createdAt': DateTime.now().toIso8601String()
    },
  ];
  for (var data in samples) {
    try {
      await db.createDocument(
          databaseId: databaseId,
          collectionId: 'transactions',
          documentId: ID.unique(),
          data: data,
          permissions: [Permission.read(Role.any())]);
    } catch (_) {}
  }
}

Future<void> seedAppConfig(Databases db) async {
  print('\n⚙️ Seeding App Config...');
  final config = {
    'supportPhone': '1900 1234',
    'supportEmail': 'hotro@fixit.vn',
    'commissionRate': 15.0,
    'isMaintenance': false,
    'minVersion': '1.0.0',
    'maintenanceMessage': 'Nâng cấp hệ thống.',
    'minWithdrawal': 200000,
    'defaultLanguage': 'vi',
    'defaultTheme': 'system',
  };
  try {
    await db
        .deleteDocument(
            databaseId: databaseId,
            collectionId: 'app_config',
            documentId: 'system-settings')
        .catchError((_) {});
    await db.createDocument(
        databaseId: databaseId,
        collectionId: 'app_config',
        documentId: 'system-settings',
        data: config,
        permissions: [Permission.read(Role.any())]);
  } catch (_) {}
}
