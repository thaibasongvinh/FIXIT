// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CallModelImpl _$$CallModelImplFromJson(Map<String, dynamic> json) =>
    _$CallModelImpl(
      id: json['id'] as String,
      callerId: json['callerId'] as String,
      receiverId: json['receiverId'] as String,
      callerName: json['callerName'] as String,
      receiverName: json['receiverName'] as String,
      callerAvatar: json['callerAvatar'] as String?,
      receiverAvatar: json['receiverAvatar'] as String?,
      status: $enumDecode(_$CallStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
    );

Map<String, dynamic> _$$CallModelImplToJson(_$CallModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'callerId': instance.callerId,
      'receiverId': instance.receiverId,
      'callerName': instance.callerName,
      'receiverName': instance.receiverName,
      'callerAvatar': instance.callerAvatar,
      'receiverAvatar': instance.receiverAvatar,
      'status': _$CallStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
    };

const _$CallStatusEnumMap = {
  CallStatus.dialing: 'dialing',
  CallStatus.ringing: 'ringing',
  CallStatus.ongoing: 'ongoing',
  CallStatus.ended: 'ended',
  CallStatus.rejected: 'rejected',
  CallStatus.missed: 'missed',
};
