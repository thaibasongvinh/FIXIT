// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String? ?? '',
      technicianId: json['technicianId'] as String,
      technicianName: json['technicianName'] as String,
      technicianPhone: json['technicianPhone'] as String? ?? '',
      serviceType: json['serviceType'] as String,
      deviceInfo: json['deviceInfo'] as String,
      address: json['address'] as String,
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      estimatedPrice: (json['estimatedPrice'] as num).toInt(),
      paymentStatus:
          $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
              PaymentStatus.pending,
      isReviewed: json['isReviewed'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      cancelReason: json['cancelReason'] as String? ?? '',
      finalPrice: (json['finalPrice'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'technicianId': instance.technicianId,
      'technicianName': instance.technicianName,
      'technicianPhone': instance.technicianPhone,
      'serviceType': instance.serviceType,
      'deviceInfo': instance.deviceInfo,
      'address': instance.address,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'estimatedPrice': instance.estimatedPrice,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'isReviewed': instance.isReviewed,
      'notes': instance.notes,
      'cancelReason': instance.cancelReason,
      'finalPrice': instance.finalPrice,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.accepted: 'accepted',
  BookingStatus.inProgress: 'in_progress',
  BookingStatus.completed: 'done',
  BookingStatus.cancelled: 'cancelled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
};
