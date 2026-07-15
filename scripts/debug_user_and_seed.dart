import 'dart:convert';
import 'package:dart_appwrite/dart_appwrite.dart';

void main() async {
  final client = Client()
    ..setEndpoint('https://sgp.cloud.appwrite.io/v1')
    ..setProject('6a145b8d001aa82f4dd5')
    ..setKey('standard_6de4d38760a772bd4006cc26d99353ed12f03e1e9f1a743be083627ec864bb7cb9e58478865c1b8823f1f3793dcde25baaeba78244b8a8e8a5530da6412db68a1c00d329da03c6d19f57718c4714d6950d3218a33d2db9ba5001f12cd6f83352314888399d0cd72648989495cc06535781e57585cf7fc28b830f4e2a194f495b');

  final users = Users(client);
  final databases = Databases(client);
  const dbId = 'database-default';

  try {
    print('--- FINDING USER ---');
    final userList = await users.list();
    final targetUser = userList.users.firstWhere((u) => u.email == 'songca15092006@gmail.com');
    final String uid = targetUser.$id;
    print('Target User ID: $uid');

    final String techId = 'tech_nam';
    final String roomId = 'chat_${uid.substring(0, 5)}_nam';

    print('\n--- GENERATING TWO-WAY CONVERSATION HISTORY ---');

    // 1. Dọn dẹp tin nhắn cũ của phòng này
    try {
      final oldMessages = await databases.listDocuments(
        databaseId: dbId,
        collectionId: 'chat_messages',
        queries: [Query.equal('roomId', roomId), Query.limit(100)],
      );
      for (var doc in oldMessages.documents) {
        await databases.deleteDocument(databaseId: dbId, collectionId: 'chat_messages', documentId: doc.$id);
      }
      print('Cleaned up room: $roomId');
    } catch (e) {}

    // 2. Kịch bản hội thoại 2 chiều
    final conversation = [
      {'sender': techId, 'text': 'Chào bạn, tôi là Nam - thợ điện của FixIt đây ạ.'},
      {'sender': uid, 'text': 'Chào anh Nam, bảng điện nhà tôi đang bị chập chờn.'},
      {'sender': techId, 'text': 'Dạ vâng, tôi đã nhận được thông tin và địa chỉ rồi.'},
      {'sender': techId, 'text': 'Anh có thể chụp cho tôi xem tình trạng bảng điện được không?'},
      {'sender': uid, 'text': 'Đợi tôi một chút tôi gửi ảnh cho anh nhé.'},
      {'sender': techId, 'text': 'Vâng ạ, tôi đang trên đường đến, khoảng 10 phút nữa tôi có mặt.'},
      {'sender': techId, 'text': 'Tôi sẽ mang theo thang và dụng cụ đầy đủ.'},
    ];

    for (var i = 0; i < conversation.length; i++) {
      final item = conversation[i];
      await databases.createDocument(
        databaseId: dbId,
        collectionId: 'chat_messages',
        documentId: ID.unique(),
        data: {
          'roomId': roomId,
          'senderId': item['sender'],
          'text': item['text'],
          'type': 'text',
          'createdAt': DateTime.now().subtract(Duration(minutes: conversation.length - i)).toIso8601String(),
          'isRead': true,
        },
        permissions: [Permission.read(Role.any()), Permission.write(Role.any())],
      );
    }

    // Cập nhật last message cho phòng
    await databases.updateDocument(
      databaseId: dbId,
      collectionId: 'chat_rooms',
      documentId: roomId,
      data: {
        'lastMessage': conversation.last['text'],
        'lastMessageAt': DateTime.now().toIso8601String(),
        'unreadCount': jsonEncode({uid: 0, techId: 0}), // Để là 0 cho giống lịch sử đã xem
      },
    );

    print('Done generating conversation history.');

  } catch (e) {
    print('Global Error: $e');
  }
}
