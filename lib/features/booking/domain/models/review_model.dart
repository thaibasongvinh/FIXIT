import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    required String bookingId,
    required String customerId,
    required String customerName,
    required String technicianId,
    required int rating,
    required String content,
    @Default([]) List<String> photos,
    DateTime? createdAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}
