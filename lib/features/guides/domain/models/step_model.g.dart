// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StepModelImpl _$$StepModelImplFromJson(Map<String, dynamic> json) =>
    _$StepModelImpl(
      id: json['id'] as String,
      order: (json['order'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoUrl: json['videoUrl'] as String? ?? '',
      warningNote: json['warningNote'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$StepModelImplToJson(_$StepModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'title': instance.title,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'videoUrl': instance.videoUrl,
      'warningNote': instance.warningNote,
      'duration': instance.duration,
    };
