// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  String get id => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get technicianId => throw _privateConstructorUsedError;
  String get technicianName => throw _privateConstructorUsedError;
  String get technicianPhone => throw _privateConstructorUsedError;
  String get serviceType => throw _privateConstructorUsedError;
  String get deviceInfo => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  int get estimatedPrice => throw _privateConstructorUsedError;
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;
  bool get isReviewed => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get cancelReason => throw _privateConstructorUsedError;
  int? get finalPrice => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
          BookingModel value, $Res Function(BookingModel) then) =
      _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call(
      {String id,
      String customerId,
      String customerName,
      String customerPhone,
      String technicianId,
      String technicianName,
      String technicianPhone,
      String serviceType,
      String deviceInfo,
      String address,
      BookingStatus status,
      int estimatedPrice,
      PaymentStatus paymentStatus,
      bool isReviewed,
      String notes,
      String cancelReason,
      int? finalPrice,
      double? latitude,
      double? longitude,
      DateTime? scheduledAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? technicianId = null,
    Object? technicianName = null,
    Object? technicianPhone = null,
    Object? serviceType = null,
    Object? deviceInfo = null,
    Object? address = null,
    Object? status = null,
    Object? estimatedPrice = null,
    Object? paymentStatus = null,
    Object? isReviewed = null,
    Object? notes = null,
    Object? cancelReason = null,
    Object? finalPrice = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? scheduledAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      technicianName: null == technicianName
          ? _value.technicianName
          : technicianName // ignore: cast_nullable_to_non_nullable
              as String,
      technicianPhone: null == technicianPhone
          ? _value.technicianPhone
          : technicianPhone // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: null == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      estimatedPrice: null == estimatedPrice
          ? _value.estimatedPrice
          : estimatedPrice // ignore: cast_nullable_to_non_nullable
              as int,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: null == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String,
      finalPrice: freezed == finalPrice
          ? _value.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
          _$BookingModelImpl value, $Res Function(_$BookingModelImpl) then) =
      __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String customerId,
      String customerName,
      String customerPhone,
      String technicianId,
      String technicianName,
      String technicianPhone,
      String serviceType,
      String deviceInfo,
      String address,
      BookingStatus status,
      int estimatedPrice,
      PaymentStatus paymentStatus,
      bool isReviewed,
      String notes,
      String cancelReason,
      int? finalPrice,
      double? latitude,
      double? longitude,
      DateTime? scheduledAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
      _$BookingModelImpl _value, $Res Function(_$BookingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? customerPhone = null,
    Object? technicianId = null,
    Object? technicianName = null,
    Object? technicianPhone = null,
    Object? serviceType = null,
    Object? deviceInfo = null,
    Object? address = null,
    Object? status = null,
    Object? estimatedPrice = null,
    Object? paymentStatus = null,
    Object? isReviewed = null,
    Object? notes = null,
    Object? cancelReason = null,
    Object? finalPrice = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? scheduledAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BookingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      technicianName: null == technicianName
          ? _value.technicianName
          : technicianName // ignore: cast_nullable_to_non_nullable
              as String,
      technicianPhone: null == technicianPhone
          ? _value.technicianPhone
          : technicianPhone // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: null == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      estimatedPrice: null == estimatedPrice
          ? _value.estimatedPrice
          : estimatedPrice // ignore: cast_nullable_to_non_nullable
              as int,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      isReviewed: null == isReviewed
          ? _value.isReviewed
          : isReviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      cancelReason: null == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String,
      finalPrice: freezed == finalPrice
          ? _value.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
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
class _$BookingModelImpl implements _BookingModel {
  const _$BookingModelImpl(
      {required this.id,
      required this.customerId,
      required this.customerName,
      this.customerPhone = '',
      required this.technicianId,
      required this.technicianName,
      this.technicianPhone = '',
      required this.serviceType,
      required this.deviceInfo,
      required this.address,
      required this.status,
      required this.estimatedPrice,
      this.paymentStatus = PaymentStatus.pending,
      this.isReviewed = false,
      this.notes = '',
      this.cancelReason = '',
      this.finalPrice,
      this.latitude,
      this.longitude,
      this.scheduledAt,
      this.createdAt,
      this.updatedAt});

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final String id;
  @override
  final String customerId;
  @override
  final String customerName;
  @override
  @JsonKey()
  final String customerPhone;
  @override
  final String technicianId;
  @override
  final String technicianName;
  @override
  @JsonKey()
  final String technicianPhone;
  @override
  final String serviceType;
  @override
  final String deviceInfo;
  @override
  final String address;
  @override
  final BookingStatus status;
  @override
  final int estimatedPrice;
  @override
  @JsonKey()
  final PaymentStatus paymentStatus;
  @override
  @JsonKey()
  final bool isReviewed;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final String cancelReason;
  @override
  final int? finalPrice;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final DateTime? scheduledAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BookingModel(id: $id, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, technicianId: $technicianId, technicianName: $technicianName, technicianPhone: $technicianPhone, serviceType: $serviceType, deviceInfo: $deviceInfo, address: $address, status: $status, estimatedPrice: $estimatedPrice, paymentStatus: $paymentStatus, isReviewed: $isReviewed, notes: $notes, cancelReason: $cancelReason, finalPrice: $finalPrice, latitude: $latitude, longitude: $longitude, scheduledAt: $scheduledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.technicianId, technicianId) ||
                other.technicianId == technicianId) &&
            (identical(other.technicianName, technicianName) ||
                other.technicianName == technicianName) &&
            (identical(other.technicianPhone, technicianPhone) ||
                other.technicianPhone == technicianPhone) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedPrice, estimatedPrice) ||
                other.estimatedPrice == estimatedPrice) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.isReviewed, isReviewed) ||
                other.isReviewed == isReviewed) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.finalPrice, finalPrice) ||
                other.finalPrice == finalPrice) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        customerId,
        customerName,
        customerPhone,
        technicianId,
        technicianName,
        technicianPhone,
        serviceType,
        deviceInfo,
        address,
        status,
        estimatedPrice,
        paymentStatus,
        isReviewed,
        notes,
        cancelReason,
        finalPrice,
        latitude,
        longitude,
        scheduledAt,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(
      this,
    );
  }
}

abstract class _BookingModel implements BookingModel {
  const factory _BookingModel(
      {required final String id,
      required final String customerId,
      required final String customerName,
      final String customerPhone,
      required final String technicianId,
      required final String technicianName,
      final String technicianPhone,
      required final String serviceType,
      required final String deviceInfo,
      required final String address,
      required final BookingStatus status,
      required final int estimatedPrice,
      final PaymentStatus paymentStatus,
      final bool isReviewed,
      final String notes,
      final String cancelReason,
      final int? finalPrice,
      final double? latitude,
      final double? longitude,
      final DateTime? scheduledAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$BookingModelImpl;

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get customerId;
  @override
  String get customerName;
  @override
  String get customerPhone;
  @override
  String get technicianId;
  @override
  String get technicianName;
  @override
  String get technicianPhone;
  @override
  String get serviceType;
  @override
  String get deviceInfo;
  @override
  String get address;
  @override
  BookingStatus get status;
  @override
  int get estimatedPrice;
  @override
  PaymentStatus get paymentStatus;
  @override
  bool get isReviewed;
  @override
  String get notes;
  @override
  String get cancelReason;
  @override
  int? get finalPrice;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  DateTime? get scheduledAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
