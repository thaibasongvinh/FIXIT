// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      technicianId: json['technicianId'] as String,
      rating: (json['rating'] as num).toInt(),
      content: json['content'] as String,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'technicianId': instance.technicianId,
      'rating': instance.rating,
      'content': instance.content,
      'photos': instance.photos,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
