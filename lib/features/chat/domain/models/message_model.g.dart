// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: $enumDecodeNullable(_$ChatMessageTypeEnumMap, json['type']) ??
          ChatMessageType.text,
      imageUrl: json['imageUrl'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': _$ChatMessageTypeEnumMap[instance.type]!,
      'imageUrl': instance.imageUrl,
      'isRead': instance.isRead,
    };

const _$ChatMessageTypeEnumMap = {
  ChatMessageType.text: 'text',
  ChatMessageType.image: 'image',
};
