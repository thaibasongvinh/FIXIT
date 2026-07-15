// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StepModel _$StepModelFromJson(Map<String, dynamic> json) {
  return _StepModel.fromJson(json);
}

/// @nodoc
mixin _$StepModel {
  String get id => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;
  String get warningNote => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StepModelCopyWith<StepModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StepModelCopyWith<$Res> {
  factory $StepModelCopyWith(StepModel value, $Res Function(StepModel) then) =
      _$StepModelCopyWithImpl<$Res, StepModel>;
  @useResult
  $Res call(
      {String id,
      int order,
      String title,
      String content,
      List<String> imageUrls,
      String videoUrl,
      String warningNote,
      int duration});
}

/// @nodoc
class _$StepModelCopyWithImpl<$Res, $Val extends StepModel>
    implements $StepModelCopyWith<$Res> {
  _$StepModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? title = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? videoUrl = null,
    Object? warningNote = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      warningNote: null == warningNote
          ? _value.warningNote
          : warningNote // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StepModelImplCopyWith<$Res>
    implements $StepModelCopyWith<$Res> {
  factory _$$StepModelImplCopyWith(
          _$StepModelImpl value, $Res Function(_$StepModelImpl) then) =
      __$$StepModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int order,
      String title,
      String content,
      List<String> imageUrls,
      String videoUrl,
      String warningNote,
      int duration});
}

/// @nodoc
class __$$StepModelImplCopyWithImpl<$Res>
    extends _$StepModelCopyWithImpl<$Res, _$StepModelImpl>
    implements _$$StepModelImplCopyWith<$Res> {
  __$$StepModelImplCopyWithImpl(
      _$StepModelImpl _value, $Res Function(_$StepModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? title = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? videoUrl = null,
    Object? warningNote = null,
    Object? duration = null,
  }) {
    return _then(_$StepModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      warningNote: null == warningNote
          ? _value.warningNote
          : warningNote // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StepModelImpl implements _StepModel {
  const _$StepModelImpl(
      {required this.id,
      required this.order,
      required this.title,
      required this.content,
      final List<String> imageUrls = const [],
      this.videoUrl = '',
      this.warningNote = '',
      this.duration = 1})
      : _imageUrls = imageUrls;

  factory _$StepModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StepModelImplFromJson(json);

  @override
  final String id;
  @override
  final int order;
  @override
  final String title;
  @override
  final String content;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  final String videoUrl;
  @override
  @JsonKey()
  final String warningNote;
  @override
  @JsonKey()
  final int duration;

  @override
  String toString() {
    return 'StepModel(id: $id, order: $order, title: $title, content: $content, imageUrls: $imageUrls, videoUrl: $videoUrl, warningNote: $warningNote, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StepModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.warningNote, warningNote) ||
                other.warningNote == warningNote) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      order,
      title,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      videoUrl,
      warningNote,
      duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StepModelImplCopyWith<_$StepModelImpl> get copyWith =>
      __$$StepModelImplCopyWithImpl<_$StepModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StepModelImplToJson(
      this,
    );
  }
}

abstract class _StepModel implements StepModel {
  const factory _StepModel(
      {required final String id,
      required final int order,
      required final String title,
      required final String content,
      final List<String> imageUrls,
      final String videoUrl,
      final String warningNote,
      final int duration}) = _$StepModelImpl;

  factory _StepModel.fromJson(Map<String, dynamic> json) =
      _$StepModelImpl.fromJson;

  @override
  String get id;
  @override
  int get order;
  @override
  String get title;
  @override
  String get content;
  @override
  List<String> get imageUrls;
  @override
  String get videoUrl;
  @override
  String get warningNote;
  @override
  int get duration;
  @override
  @JsonKey(ignore: true)
  _$$StepModelImplCopyWith<_$StepModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
