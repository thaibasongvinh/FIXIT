// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;
  String get dob => throw _privateConstructorUsedError;
  List<String> get addresses =>
      throw _privateConstructorUsedError; // Changed from String to List
  UserRole get role => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  String get verifiedStatus =>
      throw _privateConstructorUsedError; // 'unverified', 'pending', 'approved', 'rejected'
  String? get identityNumber => throw _privateConstructorUsedError;
  String? get identityCardFront => throw _privateConstructorUsedError;
  String? get identityCardBack => throw _privateConstructorUsedError;
  bool get isActive =>
      throw _privateConstructorUsedError; // Trạng thái tài khoản
  String? get pushToken => throw _privateConstructorUsedError;
  DateTime? get phoneVerifiedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String name,
      String email,
      String phone,
      String avatar,
      String dob,
      List<String> addresses,
      UserRole role,
      double rating,
      int reviewCount,
      List<String> skills,
      String verifiedStatus,
      String? identityNumber,
      String? identityCardFront,
      String? identityCardBack,
      bool isActive,
      String? pushToken,
      DateTime? phoneVerifiedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? avatar = null,
    Object? dob = null,
    Object? addresses = null,
    Object? role = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? skills = null,
    Object? verifiedStatus = null,
    Object? identityNumber = freezed,
    Object? identityCardFront = freezed,
    Object? identityCardBack = freezed,
    Object? isActive = null,
    Object? pushToken = freezed,
    Object? phoneVerifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as String,
      addresses: null == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      verifiedStatus: null == verifiedStatus
          ? _value.verifiedStatus
          : verifiedStatus // ignore: cast_nullable_to_non_nullable
              as String,
      identityNumber: freezed == identityNumber
          ? _value.identityNumber
          : identityNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      identityCardFront: freezed == identityCardFront
          ? _value.identityCardFront
          : identityCardFront // ignore: cast_nullable_to_non_nullable
              as String?,
      identityCardBack: freezed == identityCardBack
          ? _value.identityCardBack
          : identityCardBack // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      pushToken: freezed == pushToken
          ? _value.pushToken
          : pushToken // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneVerifiedAt: freezed == phoneVerifiedAt
          ? _value.phoneVerifiedAt
          : phoneVerifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String email,
      String phone,
      String avatar,
      String dob,
      List<String> addresses,
      UserRole role,
      double rating,
      int reviewCount,
      List<String> skills,
      String verifiedStatus,
      String? identityNumber,
      String? identityCardFront,
      String? identityCardBack,
      bool isActive,
      String? pushToken,
      DateTime? phoneVerifiedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? avatar = null,
    Object? dob = null,
    Object? addresses = null,
    Object? role = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? skills = null,
    Object? verifiedStatus = null,
    Object? identityNumber = freezed,
    Object? identityCardFront = freezed,
    Object? identityCardBack = freezed,
    Object? isActive = null,
    Object? pushToken = freezed,
    Object? phoneVerifiedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      dob: null == dob
          ? _value.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as String,
      addresses: null == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      verifiedStatus: null == verifiedStatus
          ? _value.verifiedStatus
          : verifiedStatus // ignore: cast_nullable_to_non_nullable
              as String,
      identityNumber: freezed == identityNumber
          ? _value.identityNumber
          : identityNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      identityCardFront: freezed == identityCardFront
          ? _value.identityCardFront
          : identityCardFront // ignore: cast_nullable_to_non_nullable
              as String?,
      identityCardBack: freezed == identityCardBack
          ? _value.identityCardBack
          : identityCardBack // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      pushToken: freezed == pushToken
          ? _value.pushToken
          : pushToken // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneVerifiedAt: freezed == phoneVerifiedAt
          ? _value.phoneVerifiedAt
          : phoneVerifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.uid,
      required this.name,
      required this.email,
      this.phone = '',
      this.avatar = '',
      this.dob = '',
      final List<String> addresses = const [],
      this.role = UserRole.none,
      this.rating = 0.0,
      this.reviewCount = 0,
      final List<String> skills = const [],
      this.verifiedStatus = 'unverified',
      this.identityNumber,
      this.identityCardFront,
      this.identityCardBack,
      this.isActive = true,
      this.pushToken,
      this.phoneVerifiedAt,
      this.createdAt,
      this.updatedAt})
      : _addresses = addresses,
        _skills = skills;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String email;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String avatar;
  @override
  @JsonKey()
  final String dob;
  final List<String> _addresses;
  @override
  @JsonKey()
  List<String> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

// Changed from String to List
  @override
  @JsonKey()
  final UserRole role;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  @JsonKey()
  final String verifiedStatus;
// 'unverified', 'pending', 'approved', 'rejected'
  @override
  final String? identityNumber;
  @override
  final String? identityCardFront;
  @override
  final String? identityCardBack;
  @override
  @JsonKey()
  final bool isActive;
// Trạng thái tài khoản
  @override
  final String? pushToken;
  @override
  final DateTime? phoneVerifiedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phone: $phone, avatar: $avatar, dob: $dob, addresses: $addresses, role: $role, rating: $rating, reviewCount: $reviewCount, skills: $skills, verifiedStatus: $verifiedStatus, identityNumber: $identityNumber, identityCardFront: $identityCardFront, identityCardBack: $identityCardBack, isActive: $isActive, pushToken: $pushToken, phoneVerifiedAt: $phoneVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.verifiedStatus, verifiedStatus) ||
                other.verifiedStatus == verifiedStatus) &&
            (identical(other.identityNumber, identityNumber) ||
                other.identityNumber == identityNumber) &&
            (identical(other.identityCardFront, identityCardFront) ||
                other.identityCardFront == identityCardFront) &&
            (identical(other.identityCardBack, identityCardBack) ||
                other.identityCardBack == identityCardBack) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.pushToken, pushToken) ||
                other.pushToken == pushToken) &&
            (identical(other.phoneVerifiedAt, phoneVerifiedAt) ||
                other.phoneVerifiedAt == phoneVerifiedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uid,
        name,
        email,
        phone,
        avatar,
        dob,
        const DeepCollectionEquality().hash(_addresses),
        role,
        rating,
        reviewCount,
        const DeepCollectionEquality().hash(_skills),
        verifiedStatus,
        identityNumber,
        identityCardFront,
        identityCardBack,
        isActive,
        pushToken,
        phoneVerifiedAt,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String uid,
      required final String name,
      required final String email,
      final String phone,
      final String avatar,
      final String dob,
      final List<String> addresses,
      final UserRole role,
      final double rating,
      final int reviewCount,
      final List<String> skills,
      final String verifiedStatus,
      final String? identityNumber,
      final String? identityCardFront,
      final String? identityCardBack,
      final bool isActive,
      final String? pushToken,
      final DateTime? phoneVerifiedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get avatar;
  @override
  String get dob;
  @override
  List<String> get addresses;
  @override // Changed from String to List
  UserRole get role;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  List<String> get skills;
  @override
  String get verifiedStatus;
  @override // 'unverified', 'pending', 'approved', 'rejected'
  String? get identityNumber;
  @override
  String? get identityCardFront;
  @override
  String? get identityCardBack;
  @override
  bool get isActive;
  @override // Trạng thái tài khoản
  String? get pushToken;
  @override
  DateTime? get phoneVerifiedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
