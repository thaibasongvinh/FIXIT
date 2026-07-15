import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appwrite/models.dart' as models;

part 'message_model.freezed.dart';
part 'message_model.g.dart';

enum ChatMessageType { text, image }

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderId,
    required String text,
    required DateTime createdAt,
    @Default(ChatMessageType.text) ChatMessageType type,
    @Default('') String imageUrl,
    @Default(false) bool isRead,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.fromAppwrite(models.Document doc) {
    final data = doc.data;
    return ChatMessage.fromJson({
      ...data,
      'id': doc.$id,
      'createdAt': data['createdAt'] ?? doc.$createdAt,
    });
  }
}
