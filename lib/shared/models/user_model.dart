import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { 
  none, 
  customer, 
  technician, 
  admin,
  moderator,
  finance_manager,
  support_staff
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String name,
    required String email,
    @Default('') String phone,
    @Default('') String avatar,
    @Default('') String dob,
    @Default([]) List<String> addresses, // Changed from String to List
    @Default(UserRole.none) UserRole role,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default([]) List<String> skills,
    @Default('unverified') String verifiedStatus, // 'unverified', 'pending', 'approved', 'rejected'
    String? identityNumber,
    String? identityCardFront,
    String? identityCardBack,
    @Default(true) bool isActive, // Trạng thái tài khoản
    String? pushToken,
    DateTime? phoneVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  bool get isTechnician => role == UserRole.technician;
  bool get isAdmin => role == UserRole.admin || role == UserRole.moderator || role == UserRole.finance_manager || role == UserRole.support_staff;
  
  bool hasPermission(List<UserRole> allowedRoles) {
    if (role == UserRole.admin) return true;
    return allowedRoles.contains(role);
  }

  bool get hasVerifiedPhone =>
      phone.trim().isNotEmpty && phoneVerifiedAt != null;
}
