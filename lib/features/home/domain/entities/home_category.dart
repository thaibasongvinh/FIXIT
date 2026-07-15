import 'package:flutter/foundation.dart';

class HomeCategory {
  final String id;
  final String title;
  final String imagePath;
  final int color;
  final bool isActive;
  final String? parentId;

  const HomeCategory({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.color,
    this.isActive = true,
    this.parentId,
  });

  /// Factory để đồng bộ dữ liệu từ Appwrite (Map) sang Model
  factory HomeCategory.fromMap(Map<String, dynamic> data, String id) {
    // Logic xử lý màu từ Hex String (#FFFFFF) sang Int (0xFFFFFFFF)
    String colorStr = data['color']?.toString() ?? '#F2C94C';
    int colorInt = 0xFFF2C94C;
    try {
      if (colorStr.startsWith('#')) {
        colorInt = int.parse(colorStr.replaceFirst('#', '0xFF'));
      }
    } catch (_) {
      debugPrint('HomeCategory: Error parsing color $colorStr for doc $id');
    }

    return HomeCategory(
      id: id,
      title: data['title']?.toString() ?? data['name']?.toString() ?? id,
      imagePath: data['imagePath']?.toString() ?? '',
      color: colorInt,
      isActive: data['isActive'] is bool ? data['isActive'] : true,
      parentId: data['parentId']?.toString(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          imagePath == other.imagePath &&
          color == other.color &&
          isActive == other.isActive &&
          parentId == other.parentId;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      imagePath.hashCode ^
      color.hashCode ^
      isActive.hashCode ^
      parentId.hashCode;
}
