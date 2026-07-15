import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appwrite/models.dart' as models;

part 'call_model.freezed.dart';
part 'call_model.g.dart';

enum CallStatus { dialing, ringing, ongoing, ended, rejected, missed }

@freezed
class CallModel with _$CallModel {
  const factory CallModel({
    required String id,
    required String callerId,
    required String receiverId,
    required String callerName,
    required String receiverName,
    String? callerAvatar,
    String? receiverAvatar,
    required CallStatus status,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
  }) = _CallModel;

  factory CallModel.fromJson(Map<String, dynamic> json) =>
      _$CallModelFromJson(json);

  factory CallModel.fromAppwrite(models.Document doc) {
    final data = doc.data;
    return CallModel.fromJson({
      ...data,
      'id': doc.$id,
      'status': data['status'] ?? CallStatus.dialing.name,
      'createdAt': data['createdAt'] ?? doc.$createdAt,
    });
  }
}
