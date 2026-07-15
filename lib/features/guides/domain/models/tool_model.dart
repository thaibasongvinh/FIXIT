import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_model.freezed.dart';
part 'tool_model.g.dart';

@freezed
class ToolModel with _$ToolModel {
  const factory ToolModel({
    required String id,
    required String name,
    @Default('') String description,
    @Default('') String imageUrl,
    @Default(false) bool isAvailable,
    int? price,
    String? shopUrl,
    @Default(false) bool isPart, // true if it's a replacement part, false if tool
  }) = _ToolModel;

  factory ToolModel.fromJson(Map<String, dynamic> json) =>
      _$ToolModelFromJson(json);
}
