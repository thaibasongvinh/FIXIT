import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  const String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  const String projectId = '6a145b8d001aa82f4dd5';
  const String apiKey = 'standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b';
  const String databaseId = 'database-default';

  Client client = Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey);
  Databases databases = Databases(client);

  print('🛠️ Đang cập nhật schema cho Wallet và Transactions...');

  // 1. Cập nhật Transactions
  try {
    await databases.createStringAttribute(
      databaseId: databaseId,
      collectionId: 'transactions',
      key: 'paymentMethod',
      size: 50,
      xrequired: false,
    );
    print('✅ Thành công: transactions.paymentMethod');
  } catch (e) {
    print('ℹ️ transactions.paymentMethod: $e');
  }

  // 2. Cập nhật Payment Methods (Đang thiếu rất nhiều trường so với Repository)
  final pmFields = {
    'type': 20,
    'label': 100,
    'maskedNumber': 20,
    'holderName': 100,
    'expiryDate': 10,
  };

  for (var entry in pmFields.entries) {
    try {
      await databases.createStringAttribute(
        databaseId: databaseId,
        collectionId: 'payment_methods',
        key: entry.key,
        size: entry.value,
        xrequired: false,
      );
      print('✅ Thành công: payment_methods.${entry.key}');
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      print('ℹ️ payment_methods.${entry.key}: $e');
    }
  }

  try {
    await databases.createBooleanAttribute(
      databaseId: databaseId,
      collectionId: 'payment_methods',
      key: 'isDefault',
      xrequired: false,
      xdefault: false,
    );
    print('✅ Thành công: payment_methods.isDefault');
  } catch (e) {
    print('ℹ️ payment_methods.isDefault: $e');
  }

  try {
    await databases.createBooleanAttribute(
      databaseId: databaseId,
      collectionId: 'payment_methods',
      key: 'isEnabled',
      xrequired: false,
      xdefault: true,
    );
    print('✅ Thành công: payment_methods.isEnabled');
  } catch (e) {
    print('ℹ️ payment_methods.isEnabled: $e');
  }

  print('\n🎯 Hoàn tất cập nhật schema!');
}
