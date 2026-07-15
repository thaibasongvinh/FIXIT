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

  print('🚀 Đang đẩy dữ liệu mẫu cho các tính năng nâng cao...');

  // 1. ĐẨY DỮ LIỆU COUPONS
  try {
    print('--- Đang tạo Coupons mẫu ---');
    final coupons = [
      {
        'code': 'WELCOME2024',
        'type': 'percent',
        'value': 20.0,
        'minOrder': 100000.0,
        'usageLimit': 500,
        'usedCount': 12,
        'isActive': true
      },
      {
        'code': 'FIXITFREE',
        'type': 'fixed',
        'value': 50000.0,
        'minOrder': 200000.0,
        'usageLimit': 100,
        'usedCount': 45,
        'isActive': true
      },
      {
        'code': 'SUMMERSALE',
        'type': 'percent',
        'value': 15.0,
        'minOrder': 0.0,
        'usageLimit': 1000,
        'usedCount': 0,
        'isActive': false
      },
    ];

    for (var c in coupons) {
      await databases.createDocument(
          databaseId: databaseId,
          collectionId: 'coupons',
          documentId: ID.unique(),
          data: {
            ...c,
            'expiry':
                DateTime.now().add(const Duration(days: 60)).toIso8601String()
          });
    }
    print('✅ Tạo Coupons thành công');
  } catch (e) {
    print('⚠️ Lỗi Coupons: $e');
  }

  // 2. ĐẨY DỮ LIỆU NHẬT KÝ (AUDIT LOGS)
  try {
    print('--- Đang tạo Nhật ký hoạt động mẫu ---');
    final logs = [
      {
        'adminName': 'Fixit Admin',
        'action': 'Updated System Config',
        'target': 'Maintenance Mode ON'
      },
      {
        'adminName': 'Fixit Admin',
        'action': 'Deleted Service',
        'target': 'Old Plumber Service'
      },
      {
        'adminName': 'Kế toán 01',
        'action': 'Exported Report',
        'target': 'Revenue June 2026'
      },
      {
        'adminName': 'Fixit Admin',
        'action': 'Approved Technician',
        'target': 'Lê Văn C'
      },
    ];

    for (var l in logs) {
      await databases.createDocument(
          databaseId: databaseId,
          collectionId: 'audit_logs',
          documentId: ID.unique(),
          data: {
            ...l,
            'createdAt': DateTime.now()
                .subtract(const Duration(hours: 2))
                .toIso8601String()
          });
    }
    print('✅ Tạo Audit Logs thành công');
  } catch (e) {
    print('⚠️ Lỗi Audit Logs: $e');
  }

  // 3. CẬP NHẬT THỢ TRỰC TUYẾN (Dành cho bản đồ)
  try {
    print('--- Đang cập nhật trạng thái trực tuyến cho Thợ ---');
    // Lấy danh sách thợ hiện có
    final techs = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: 'technicians',
        queries: [Query.limit(5)]);

    // Giả lập vị trí tại TP.HCM cho một số thợ
    final coords = [
      {'lat': 10.762622, 'lng': 106.660172},
      {'lat': 10.776889, 'lng': 106.700806},
      {'lat': 10.823099, 'lng': 106.629654},
    ];

    for (int i = 0; i < techs.documents.length; i++) {
      if (i < coords.length) {
        await databases.updateDocument(
            databaseId: databaseId,
            collectionId: 'technicians',
            documentId: techs.documents[i].$id,
            data: {
              'isOnline': true,
              'lat': coords[i]['lat'],
              'lng': coords[i]['lng']
            });
      }
    }
    print('✅ Cập nhật vị trí thợ thành công');
  } catch (e) {
    print('⚠️ Lỗi Technicians Map: $e');
  }

  print('\n🎯 Hoàn tất đẩy dữ liệu mẫu. Hãy mở ứng dụng để kiểm tra!');
}
