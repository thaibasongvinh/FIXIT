import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/chat/presentation/providers/chat_provider.dart';
import 'package:fixit/features/chat/domain/models/message_model.dart';

/// HÀM NÀY CHỈ DÙNG ĐỂ TẠO DỮ LIỆU MẪU CHO BÁO CÁO
Future<void> seedSampleData(WidgetRef ref) async {
  final user = ref.read(currentUserProvider).valueOrNull;
  if (user == null) return;

  final db = ref.read(appwriteDatabasesProvider);
  final env = ref.read(appEnvironmentProvider);
  final chatNotifier = ref.read(chatNotifierProvider.notifier);

  final String uid = user.uid;
  final String technicianId = 'tech_sample';
  final String roomId = 'chat_${uid.substring(0, 10)}';

  try {
    // Kiểm tra xem phòng chat đã tồn tại chưa để tránh tạo trùng lặp quá nhiều
    try {
      await db.getDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'chat_rooms',
        documentId: roomId,
      );
      print('Dữ liệu mẫu đã tồn tại, bỏ qua tạo mới.');
      return; 
    } catch (_) {
      // Nếu lỗi 404 thì tiếp tục tạo mới
    }

    // 1. Tạo dữ liệu Chat mẫu
    await chatNotifier.sendMessage(
      roomId,
      technicianId, // Người gửi là Thợ
      'Chào bạn, tôi đã nhận được yêu cầu sửa chữa ống nước của bạn. Tôi sẽ đến trong khoảng 30 phút nữa nhé!',
      'booking_sample_1',
      [uid, technicianId],
    );

    // Force update unread count for the user manually to be sure
    final roomDoc = await db.getDocument(
      databaseId: env.appwriteDatabaseId,
      collectionId: 'chat_rooms',
      documentId: roomId,
    );
    Map<String, dynamic> unreadMap = Map<String, dynamic>.from(roomDoc.data['unreadCount'] ?? {});
    unreadMap[uid] = 2; // Giả lập có 2 tin nhắn chưa đọc

    await db.updateDocument(
      databaseId: env.appwriteDatabaseId,
      collectionId: 'chat_rooms',
      documentId: roomId,
      data: {'unreadCount': unreadMap},
    );

    await chatNotifier.sendMessage(
      roomId,
      technicianId, // Người gửi là Thợ
      'Bạn có thể gửi cho tôi hình ảnh vị trí ống bị rò rỉ không?',
      'booking_sample_1',
      [uid, technicianId],
    );

    // 2. Tạo dữ liệu Thông báo mẫu
    final notifications = [
      {
        'userId': uid,
        'title': 'Đơn hàng mới',
        'body': 'Yêu cầu sửa chữa điện của bạn đã được thợ Nguyễn Văn Nam tiếp nhận.',
        'type': 'booking_update',
        'relatedId': 'booking_sample_1',
        'isRead': false,
        'createdAt': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
      },
      {
        'userId': uid,
        'title': 'Thanh toán thành công',
        'body': 'Bạn đã thanh toán 250.000đ cho dịch vụ Vệ sinh máy lạnh.',
        'type': 'payment_success',
        'relatedId': 'payment_sample_1',
        'isRead': false,
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'userId': uid,
        'title': 'Hồ sơ đã duyệt',
        'body': 'Chúc mừng! Hồ sơ nâng cấp lên Thợ Chuyên Nghiệp của bạn đã được phê duyệt.',
        'type': 'application_status',
        'relatedId': 'app_sample_1',
        'isRead': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
    ];

    for (final notif in notifications) {
      await db.createDocument(
        databaseId: env.appwriteDatabaseId,
        collectionId: 'notifications',
        documentId: ID.unique(),
        data: notif,
      );
    }

    print('Đã tạo dữ liệu mẫu thành công!');
  } catch (e) {
    print('Lỗi khi tạo dữ liệu mẫu: $e');
  }
}
