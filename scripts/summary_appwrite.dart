import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final client = Client()
    ..setEndpoint('https://sgp.cloud.appwrite.io/v1')
    ..setProject('6a145b8d001aa82f4dd5')
    ..setKey('standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b');

  final databases = Databases(client);
  const dbId = 'database-default';

  final collections = [
    'users',
    'chat_rooms',
    'chat_messages',
    'notifications',
    'bookings',
    'services',
    'products',
    'wallets',
    'transactions'
  ];

  print('--- APPWRITE DATABASE SUMMARY ---');
  for (final col in collections) {
    try {
      final response = await databases.listDocuments(
        databaseId: dbId,
        collectionId: col,
        queries: [Query.limit(1)],
      );
      print('Collection: ${col.padRight(15)} | Count: ${response.total}');
    } catch (e) {
      print('Collection: ${col.padRight(15)} | Error: $e');
    }
  }
  print('----------------------------------');
}
