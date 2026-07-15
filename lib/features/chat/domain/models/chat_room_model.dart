import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appwrite/models.dart' as models;

part 'chat_room_model.freezed.dart';
part 'chat_room_model.g.dart';

@freezed
class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    required String id,
    required List<String> participants,
    required String lastMessage,
    required DateTime lastMessageAt,
    required String bookingId,
    @Default({}) Map<String, int> unreadCount,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  factory ChatRoom.fromAppwrite(models.Document doc) {
    final data = doc.data;
    
    // Parse unreadCount from JSON String if necessary
    Map<String, int> unreadMap = {};
    if (data['unreadCount'] is String) {
      try {
        final decoded = Map<String, dynamic>.from(jsonDecode(data['unreadCount']));
        unreadMap = decoded.map((key, value) => MapEntry(key, value as int));
      } catch (_) {}
    } else if (data['unreadCount'] is Map) {
      unreadMap = Map<String, int>.from(data['unreadCount']);
    }

    return ChatRoom.fromJson({
      ...data,
      'id': doc.$id,
      'unreadCount': unreadMap,
      'lastMessageAt': data['lastMessageAt'] ?? doc.$updatedAt,
    });
  }
}
