import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appwrite/models.dart' as models;

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

// ── Booking Status enum ──────────────────────────────
enum BookingStatus {
  pending,
  accepted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('done')
  completed,
  cancelled;

  static BookingStatus fromValue(String? value) => switch (value) {
        'accepted' => accepted,
        'in_progress' || 'inProgress' => inProgress,
        'done' || 'completed' => completed,
        'cancelled' => cancelled,
        _ => pending,
      };

  String get appwriteValue => switch (this) {
        pending => 'pending',
        accepted => 'accepted',
        inProgress => 'in_progress',
        completed => 'done',
        cancelled => 'cancelled',
      };

  String get label => switch (this) {
        pending => '⏳ Chờ xác nhận',
        accepted => '✅ Đã nhận đơn',
        inProgress => '🔧 Đang sửa chữa',
        completed => '🎉 Hoàn thành',
        cancelled => '❌ Đã huỷ',
      };

  bool get isPending => this == pending;
  bool get isActive => this == accepted || this == inProgress;
  bool get isCompleted => this == completed;
  bool get isCancelled => this == cancelled;
  bool get canBeCancelled => this == pending || this == accepted;
}

enum PaymentStatus {
  pending,
  paid;

  static PaymentStatus fromValue(String? value) => switch (value) {
        'paid' => paid,
        _ => pending,
      };

  String get label => switch (this) {
        pending => 'Chưa thanh toán',
        paid => 'Đã thanh toán',
      };
}

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    required String customerId,
    required String customerName,
    @Default('') String customerPhone,
    required String technicianId,
    required String technicianName,
    @Default('') String technicianPhone,
    required String serviceType,
    required String deviceInfo,
    required String address,
    required BookingStatus status,
    required int estimatedPrice,
    @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    @Default(false) bool isReviewed,
    @Default('') String notes,
    @Default('') String cancelReason,
    int? finalPrice,
    double? latitude,
    double? longitude,
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  factory BookingModel.fromAppwrite(models.Document doc) {
    final d = doc.data;
    return BookingModel(
      id: doc.$id,
      customerId: d['customerId']?.toString() ?? '',
      customerName: d['customerName']?.toString() ?? '',
      customerPhone: d['customerPhone']?.toString() ?? '',
      technicianId: d['technicianId']?.toString() ?? '',
      technicianName: d['technicianName']?.toString() ?? '',
      technicianPhone: d['technicianPhone']?.toString() ?? '',
      serviceType: d['serviceType']?.toString() ?? '',
      deviceInfo: d['deviceInfo']?.toString() ?? '',
      address: d['address']?.toString() ?? '',
      status: BookingStatus.fromValue(d['status']?.toString()),
      estimatedPrice: (d['estimatedPrice'] as num?)?.toInt() ?? 0,
      paymentStatus: PaymentStatus.fromValue(d['paymentStatus']?.toString()),
      isReviewed: d['isReviewed'] as bool? ?? false,
      notes: d['notes']?.toString() ?? '',
      cancelReason: d['cancelReason']?.toString() ?? '',
      finalPrice: (d['finalPrice'] as num?)?.toInt(),
      latitude: (d['latitude'] as num?)?.toDouble(),
      longitude: (d['longitude'] as num?)?.toDouble(),
      scheduledAt: DateTime.tryParse(d['scheduledAt']?.toString() ?? ''),
      createdAt: DateTime.tryParse(d['createdAt']?.toString() ?? doc.$createdAt),
      updatedAt: DateTime.tryParse(d['updatedAt']?.toString() ?? doc.$updatedAt),
    );
  }
}

extension BookingModelX on BookingModel {
  String get priceText {
    final n = finalPrice ?? estimatedPrice;
    return '${n.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+$)"), (m) => "${m[1]}.")}đ';
  }
}
