// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ToolModel _$ToolModelFromJson(Map<String, dynamic> json) {
  return _ToolModel.fromJson(json);
}

/// @nodoc
mixin _$ToolModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  String? get shopUrl => throw _privateConstructorUsedError;
  bool get isPart => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ToolModelCopyWith<ToolModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToolModelCopyWith<$Res> {
  factory $ToolModelCopyWith(ToolModel value, $Res Function(ToolModel) then) =
      _$ToolModelCopyWithImpl<$Res, ToolModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String imageUrl,
      bool isAvailable,
      int? price,
      String? shopUrl,
      bool isPart});
}

/// @nodoc
class _$ToolModelCopyWithImpl<$Res, $Val extends ToolModel>
    implements $ToolModelCopyWith<$Res> {
  _$ToolModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? isAvailable = null,
    Object? price = freezed,
    Object? shopUrl = freezed,
    Object? isPart = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      shopUrl: freezed == shopUrl
          ? _value.shopUrl
          : shopUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPart: null == isPart
          ? _value.isPart
          : isPart // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToolModelImplCopyWith<$Res>
    implements $ToolModelCopyWith<$Res> {
  factory _$$ToolModelImplCopyWith(
          _$ToolModelImpl value, $Res Function(_$ToolModelImpl) then) =
      __$$ToolModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String imageUrl,
      bool isAvailable,
      int? price,
      String? shopUrl,
      bool isPart});
}

/// @nodoc
class __$$ToolModelImplCopyWithImpl<$Res>
    extends _$ToolModelCopyWithImpl<$Res, _$ToolModelImpl>
    implements _$$ToolModelImplCopyWith<$Res> {
  __$$ToolModelImplCopyWithImpl(
      _$ToolModelImpl _value, $Res Function(_$ToolModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? isAvailable = null,
    Object? price = freezed,
    Object? shopUrl = freezed,
    Object? isPart = null,
  }) {
    return _then(_$ToolModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      shopUrl: freezed == shopUrl
          ? _value.shopUrl
          : shopUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPart: null == isPart
          ? _value.isPart
          : isPart // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ToolModelImpl implements _ToolModel {
  const _$ToolModelImpl(
      {required this.id,
      required this.name,
      this.description = '',
      this.imageUrl = '',
      this.isAvailable = false,
      this.price,
      this.shopUrl,
      this.isPart = false});

  factory _$ToolModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToolModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String imageUrl;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final int? price;
  @override
  final String? shopUrl;
  @override
  @JsonKey()
  final bool isPart;

  @override
  String toString() {
    return 'ToolModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl, isAvailable: $isAvailable, price: $price, shopUrl: $shopUrl, isPart: $isPart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToolModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.shopUrl, shopUrl) || other.shopUrl == shopUrl) &&
            (identical(other.isPart, isPart) || other.isPart == isPart));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, imageUrl,
      isAvailable, price, shopUrl, isPart);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ToolModelImplCopyWith<_$ToolModelImpl> get copyWith =>
      __$$ToolModelImplCopyWithImpl<_$ToolModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToolModelImplToJson(
      this,
    );
  }
}

abstract class _ToolModel implements ToolModel {
  const factory _ToolModel(
      {required final String id,
      required final String name,
      final String description,
      final String imageUrl,
      final bool isAvailable,
      final int? price,
      final String? shopUrl,
      final bool isPart}) = _$ToolModelImpl;

  factory _ToolModel.fromJson(Map<String, dynamic> json) =
      _$ToolModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get imageUrl;
  @override
  bool get isAvailable;
  @override
  int? get price;
  @override
  String? get shopUrl;
  @override
  bool get isPart;
  @override
  @JsonKey(ignore: true)
  _$$ToolModelImplCopyWith<_$ToolModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
