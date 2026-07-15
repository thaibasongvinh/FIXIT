// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuideModelImpl _$$GuideModelImplFromJson(Map<String, dynamic> json) =>
    _$GuideModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      device: json['device'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      coverImage: json['coverImage'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      estimatedTime: (json['estimatedTime'] as num?)?.toInt() ?? 0,
      requiredTools: (json['requiredTools'] as List<dynamic>?)
              ?.map((e) => ToolModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      requiredParts: (json['requiredParts'] as List<dynamic>?)
              ?.map((e) => ToolModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      toolsRequired: (json['toolsRequired'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      searchKeywords: (json['searchKeywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      views: (json['views'] as num?)?.toInt() ?? 0,
      bookmarks: (json['bookmarks'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      isPublished: json['isPublished'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GuideModelImplToJson(_$GuideModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'device': instance.device,
      'category': instance.category,
      'difficulty': instance.difficulty,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'coverImage': instance.coverImage,
      'slug': instance.slug,
      'estimatedTime': instance.estimatedTime,
      'requiredTools': instance.requiredTools,
      'requiredParts': instance.requiredParts,
      'toolsRequired': instance.toolsRequired,
      'tags': instance.tags,
      'searchKeywords': instance.searchKeywords,
      'views': instance.views,
      'bookmarks': instance.bookmarks,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'ratingCount': instance.ratingCount,
      'isPublished': instance.isPublished,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
