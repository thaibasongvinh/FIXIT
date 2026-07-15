// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomImpl _$$ChatRoomImplFromJson(Map<String, dynamic> json) =>
    _$ChatRoomImpl(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      bookingId: json['bookingId'] as String,
      unreadCount: (json['unreadCount'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ChatRoomImplToJson(_$ChatRoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'bookingId': instance.bookingId,
      'unreadCount': instance.unreadCount,
    };
