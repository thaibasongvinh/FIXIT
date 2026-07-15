import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appwrite/models.dart' as models;

part 'technician_model.freezed.dart';
part 'technician_model.g.dart';

@freezed
class TechnicianModel with _$TechnicianModel {
  const factory TechnicianModel({
    required String uid,
    required String name,
    required String phone,
    @Default('') String avatar,
    String? color,
    @Default('') String bio,
    @Default([]) List<String> skills,
    @Default('') String serviceArea,
    @Default(true) bool isAvailable,
    @Default(false) bool isVerified,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(0) int completedJobs,
    @Default(0) int completedOrders,
    @Default(0) int experience,
    @Default(0) int pricePerHour,
    @Default([]) List<Map<String, dynamic>> services,
    @Default([]) List<String> certifications,
    @Default([]) List<String> portfolioImages,
    @Default({}) Map<String, dynamic> workingHours,
    double? latitude,
    double? longitude,
    String? pushToken,
    DateTime? createdAt,
  }) = _TechnicianModel;

  factory TechnicianModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianModelFromJson(json);

  factory TechnicianModel.fromAppwrite(models.Document doc) {
    final d = doc.data;
    final latitude = d['latitude'];
    final longitude = d['longitude'];
    
    final name = d['name']?.toString() ?? 
                 d['Name']?.toString() ?? 
                 d['title']?.toString() ??
                 'Unknown Tech';
    
    if (name == 'Unknown Tech') {
      debugPrint('Appwrite: [WARN] Technician ${doc.$id} has no name. Data keys: ${d.keys.toList()}');
    }

    return TechnicianModel(
      uid: doc.$id,
      name: name,
      phone: d['phone']?.toString() ?? '',
      avatar: d['avatar']?.toString() ?? '',
      color: d['color']?.toString(),
      bio: d['bio']?.toString() ?? '',
      skills: List<String>.from(d['skills'] ?? []),
      serviceArea: d['serviceArea']?.toString() ?? '',
      isAvailable: d['isAvailable'] ?? true,
      isVerified: d['isVerified'] ?? false,
      rating: (d['rating'] ?? 0.0).toDouble(),
      reviewCount: d['reviewCount'] ?? 0,
      completedJobs: d['completedJobs'] ?? 0,
      completedOrders: d['completedOrders'] ?? 0,
      experience: d['experience'] ?? 0,
      pricePerHour: d['pricePerHour'] ?? 0,
      latitude: latitude is num ? latitude.toDouble() : null,
      longitude: longitude is num ? longitude.toDouble() : null,
      createdAt: DateTime.tryParse(doc.$createdAt),
    );
  }
}

extension TechnicianModelX on TechnicianModel {
  String get ratingText => '$rating ⭐ ($reviewCount đánh giá)';
  String get priceText => '${_fmt(pricePerHour)}đ/giờ';
  String _fmt(int n) => n
      .toString()
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
}
