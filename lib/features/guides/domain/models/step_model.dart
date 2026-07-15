import 'package:freezed_annotation/freezed_annotation.dart';

part 'step_model.freezed.dart';
part 'step_model.g.dart';

@freezed
class StepModel with _$StepModel {
  const factory StepModel({
    required String id,
    required int order,
    required String title,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default('') String videoUrl,
    @Default('') String warningNote,
    @Default(1) int duration,
  }) = _StepModel;

  factory StepModel.fromJson(Map<String, dynamic> json) =>
      _$StepModelFromJson(json);
}
