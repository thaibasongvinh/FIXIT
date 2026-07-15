import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appwrite/models.dart' as models;
import 'tool_model.dart';

part 'guide_model.freezed.dart';
part 'guide_model.g.dart';

@freezed
class GuideModel with _$GuideModel {
  const factory GuideModel({
    required String id,
    required String title,
    required String description,
    required String device,
    required String category,
    required String difficulty,
    required String authorId,
    required String authorName,
    @Default('') String coverImage,
    @Default('') String slug,
    @Default(0) int estimatedTime,
    @Default([]) List<ToolModel> requiredTools,
    @Default([]) List<ToolModel> requiredParts,
    @Default([]) List<String> toolsRequired,
    @Default([]) List<String> tags,
    @Default([]) List<String> searchKeywords,
    @Default(0) int views,
    @Default(0) int bookmarks,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(0) int ratingCount,
    @Default(true) bool isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _GuideModel;

  factory GuideModel.fromJson(Map<String, dynamic> json) =>
      _$GuideModelFromJson(json);

  factory GuideModel.fromAppwrite(models.Document doc) {
    try {
      final d = doc.data;
      return GuideModel.fromJson({
        'id': doc.$id,
        'title': d['title'] ?? '',
        'description': d['description'] ?? '',
        'device': d['device'] ?? '',
        'category': d['category'] ?? '',
        'difficulty': d['difficulty'] ?? '',
        'authorId': d['authorId'] ?? '',
        'authorName': d['authorName'] ?? '',
        'coverImage': d['coverImage'] ?? '',
        'slug': d['slug'] ?? '',
        'estimatedTime': d['estimatedTime'] ?? 0,
        'requiredTools': d['requiredTools'] ?? [],
        'requiredParts': d['requiredParts'] ?? [],
        'toolsRequired': d['toolsRequired'] ?? [],
        'tags': d['tags'] ?? [],
        'searchKeywords': d['searchKeywords'] ?? [],
        'views': d['views'] ?? 0,
        'bookmarks': d['bookmarks'] ?? 0,
        'rating': d['rating'] ?? 0.0,
        'reviewCount': d['reviewCount'] ?? 0,
        'ratingCount': d['ratingCount'] ?? 0,
        'isPublished': d['isPublished'] ?? true,
        'createdAt': d['createdAt'] ?? doc.$createdAt,
        'updatedAt': d['updatedAt'] ?? doc.$updatedAt,
      });
    } catch (e, stack) {
      debugPrint('Appwrite: [PARSE ERROR] GuideModel.fromAppwrite failed for ID ${doc.$id}: $e');
      debugPrint('Appwrite: [PARSE ERROR] Data was: ${doc.data}');
      debugPrint('Appwrite: [PARSE ERROR] Stack: $stack');
      rethrow;
    }
  }
}

extension GuideModelX on GuideModel {
  String get difficultyLabel => switch (difficulty) {
        'de' => '⭐ Dễ',
        'trung_binh' => '⭐⭐ Trung bình',
        'kho' => '⭐⭐⭐ Khó',
        'chuyen_gia' => '⭐⭐⭐⭐ Chuyên gia',
        _ => difficulty,
      };

  String get categoryLabel => switch (category) {
        'smartphone' => '📱 Điện thoại',
        'laptop' => '💻 Laptop',
        'xe_may' => '🏍️ Xe máy',
        'gia_dung' => '🏠 Gia dụng',
        _ => '🔧 Khác',
      };
}
