import 'package:flutter/material.dart';

class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final List<int> colors; // Lưu mã màu Int (ví dụ: 0xFF003E96)
  final bool isActive;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.colors,
    this.isActive = true,
  });

  factory BannerModel.fromMap(Map<String, dynamic> data, String id) {
    // Xử lý màu sắc: hỗ trợ cả List<String> hex hoặc List<int>
    List<int> colors = [0xFF003E96, 0xFF002A66]; // Mặc định
    if (data['colors'] is List) {
      try {
        colors = (data['colors'] as List).map((c) {
          if (c is int) return c;
          if (c is String) {
            if (c.startsWith('#')) return int.parse(c.replaceFirst('#', '0xFF'));
            return int.parse(c);
          }
          return 0xFF003E96;
        }).toList();
      } catch (e) {
        debugPrint('BannerModel: Error parsing colors: $e');
      }
    }

    return BannerModel(
      id: id,
      title: data['title']?.toString() ?? '',
      subtitle: data['subtitle']?.toString() ?? '',
      image: data['image']?.toString() ?? data['imagePath']?.toString() ?? '',
      colors: colors,
      isActive: data['isActive'] is bool ? data['isActive'] : true,
    );
  }
}
