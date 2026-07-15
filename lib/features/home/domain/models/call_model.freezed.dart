// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CallModel _$CallModelFromJson(Map<String, dynamic> json) {
  return _CallModel.fromJson(json);
}

/// @nodoc
mixin _$CallModel {
  String get id => throw _privateConstructorUsedError;
  String get callerId => throw _privateConstructorUsedError;
  String get receiverId => throw _privateConstructorUsedError;
  String get callerName => throw _privateConstructorUsedError;
  String get receiverName => throw _privateConstructorUsedError;
  String? get callerAvatar => throw _privateConstructorUsedError;
  String? get receiverAvatar => throw _privateConstructorUsedError;
  CallStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallModelCopyWith<CallModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallModelCopyWith<$Res> {
  factory $CallModelCopyWith(CallModel value, $Res Function(CallModel) then) =
      _$CallModelCopyWithImpl<$Res, CallModel>;
  @useResult
  $Res call(
      {String id,
      String callerId,
      String receiverId,
      String callerName,
      String receiverName,
      String? callerAvatar,
      String? receiverAvatar,
      CallStatus status,
      DateTime createdAt,
      DateTime? startedAt,
      DateTime? endedAt});
}

/// @nodoc
class _$CallModelCopyWithImpl<$Res, $Val extends CallModel>
    implements $CallModelCopyWith<$Res> {
  _$CallModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? callerId = null,
    Object? receiverId = null,
    Object? callerName = null,
    Object? receiverName = null,
    Object? callerAvatar = freezed,
    Object? receiverAvatar = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      callerId: null == callerId
          ? _value.callerId
          : callerId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      callerName: null == callerName
          ? _value.callerName
          : callerName // ignore: cast_nullable_to_non_nullable
              as String,
      receiverName: null == receiverName
          ? _value.receiverName
          : receiverName // ignore: cast_nullable_to_non_nullable
              as String,
      callerAvatar: freezed == callerAvatar
          ? _value.callerAvatar
          : callerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverAvatar: freezed == receiverAvatar
          ? _value.receiverAvatar
          : receiverAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallModelImplCopyWith<$Res>
    implements $CallModelCopyWith<$Res> {
  factory _$$CallModelImplCopyWith(
          _$CallModelImpl value, $Res Function(_$CallModelImpl) then) =
      __$$CallModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String callerId,
      String receiverId,
      String callerName,
      String receiverName,
      String? callerAvatar,
      String? receiverAvatar,
      CallStatus status,
      DateTime createdAt,
      DateTime? startedAt,
      DateTime? endedAt});
}

/// @nodoc
class __$$CallModelImplCopyWithImpl<$Res>
    extends _$CallModelCopyWithImpl<$Res, _$CallModelImpl>
    implements _$$CallModelImplCopyWith<$Res> {
  __$$CallModelImplCopyWithImpl(
      _$CallModelImpl _value, $Res Function(_$CallModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? callerId = null,
    Object? receiverId = null,
    Object? callerName = null,
    Object? receiverName = null,
    Object? callerAvatar = freezed,
    Object? receiverAvatar = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? endedAt = freezed,
  }) {
    return _then(_$CallModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      callerId: null == callerId
          ? _value.callerId
          : callerId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      callerName: null == callerName
          ? _value.callerName
          : callerName // ignore: cast_nullable_to_non_nullable
              as String,
      receiverName: null == receiverName
          ? _value.receiverName
          : receiverName // ignore: cast_nullable_to_non_nullable
              as String,
      callerAvatar: freezed == callerAvatar
          ? _value.callerAvatar
          : callerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverAvatar: freezed == receiverAvatar
          ? _value.receiverAvatar
          : receiverAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CallModelImpl implements _CallModel {
  const _$CallModelImpl(
      {required this.id,
      required this.callerId,
      required this.receiverId,
      required this.callerName,
      required this.receiverName,
      this.callerAvatar,
      this.receiverAvatar,
      required this.status,
      required this.createdAt,
      this.startedAt,
      this.endedAt});

  factory _$CallModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallModelImplFromJson(json);

  @override
  final String id;
  @override
  final String callerId;
  @override
  final String receiverId;
  @override
  final String callerName;
  @override
  final String receiverName;
  @override
  final String? callerAvatar;
  @override
  final String? receiverAvatar;
  @override
  final CallStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? endedAt;

  @override
  String toString() {
    return 'CallModel(id: $id, callerId: $callerId, receiverId: $receiverId, callerName: $callerName, receiverName: $receiverName, callerAvatar: $callerAvatar, receiverAvatar: $receiverAvatar, status: $status, createdAt: $createdAt, startedAt: $startedAt, endedAt: $endedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.callerId, callerId) ||
                other.callerId == callerId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.callerName, callerName) ||
                other.callerName == callerName) &&
            (identical(other.receiverName, receiverName) ||
                other.receiverName == receiverName) &&
            (identical(other.callerAvatar, callerAvatar) ||
                other.callerAvatar == callerAvatar) &&
            (identical(other.receiverAvatar, receiverAvatar) ||
                other.receiverAvatar == receiverAvatar) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      callerId,
      receiverId,
      callerName,
      receiverName,
      callerAvatar,
      receiverAvatar,
      status,
      createdAt,
      startedAt,
      endedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallModelImplCopyWith<_$CallModelImpl> get copyWith =>
      __$$CallModelImplCopyWithImpl<_$CallModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallModelImplToJson(
      this,
    );
  }
}

abstract class _CallModel implements CallModel {
  const factory _CallModel(
      {required final String id,
      required final String callerId,
      required final String receiverId,
      required final String callerName,
      required final String receiverName,
      final String? callerAvatar,
      final String? receiverAvatar,
      required final CallStatus status,
      required final DateTime createdAt,
      final DateTime? startedAt,
      final DateTime? endedAt}) = _$CallModelImpl;

  factory _CallModel.fromJson(Map<String, dynamic> json) =
      _$CallModelImpl.fromJson;

  @override
  String get id;
  @override
  String get callerId;
  @override
  String get receiverId;
  @override
  String get callerName;
  @override
  String get receiverName;
  @override
  String? get callerAvatar;
  @override
  String? get receiverAvatar;
  @override
  CallStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get endedAt;
  @override
  @JsonKey(ignore: true)
  _$$CallModelImplCopyWith<_$CallModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
