// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.none,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      verifiedStatus: json['verifiedStatus'] as String? ?? 'unverified',
      identityNumber: json['identityNumber'] as String?,
      identityCardFront: json['identityCardFront'] as String?,
      identityCardBack: json['identityCardBack'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      pushToken: json['pushToken'] as String?,
      phoneVerifiedAt: json['phoneVerifiedAt'] == null
          ? null
          : DateTime.parse(json['phoneVerifiedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'dob': instance.dob,
      'addresses': instance.addresses,
      'role': _$UserRoleEnumMap[instance.role]!,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'skills': instance.skills,
      'verifiedStatus': instance.verifiedStatus,
      'identityNumber': instance.identityNumber,
      'identityCardFront': instance.identityCardFront,
      'identityCardBack': instance.identityCardBack,
      'isActive': instance.isActive,
      'pushToken': instance.pushToken,
      'phoneVerifiedAt': instance.phoneVerifiedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.none: 'none',
  UserRole.customer: 'customer',
  UserRole.technician: 'technician',
  UserRole.admin: 'admin',
  UserRole.moderator: 'moderator',
  UserRole.finance_manager: 'finance_manager',
  UserRole.support_staff: 'support_staff',
};
