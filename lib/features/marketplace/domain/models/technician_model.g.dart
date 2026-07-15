// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TechnicianModelImpl _$$TechnicianModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TechnicianModelImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String? ?? '',
      color: json['color'] as String?,
      bio: json['bio'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      serviceArea: json['serviceArea'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      completedJobs: (json['completedJobs'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      pricePerHour: (json['pricePerHour'] as num?)?.toInt() ?? 0,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      portfolioImages: (json['portfolioImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      workingHours: json['workingHours'] as Map<String, dynamic>? ?? const {},
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      pushToken: json['pushToken'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TechnicianModelImplToJson(
        _$TechnicianModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'color': instance.color,
      'bio': instance.bio,
      'skills': instance.skills,
      'serviceArea': instance.serviceArea,
      'isAvailable': instance.isAvailable,
      'isVerified': instance.isVerified,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'completedJobs': instance.completedJobs,
      'completedOrders': instance.completedOrders,
      'experience': instance.experience,
      'pricePerHour': instance.pricePerHour,
      'services': instance.services,
      'certifications': instance.certifications,
      'portfolioImages': instance.portfolioImages,
      'workingHours': instance.workingHours,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pushToken': instance.pushToken,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
