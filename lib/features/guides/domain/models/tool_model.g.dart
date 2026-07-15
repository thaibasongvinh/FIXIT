// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToolModelImpl _$$ToolModelImplFromJson(Map<String, dynamic> json) =>
    _$ToolModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? false,
      price: (json['price'] as num?)?.toInt(),
      shopUrl: json['shopUrl'] as String?,
      isPart: json['isPart'] as bool? ?? false,
    );

Map<String, dynamic> _$$ToolModelImplToJson(_$ToolModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'shopUrl': instance.shopUrl,
      'isPart': instance.isPart,
    };
