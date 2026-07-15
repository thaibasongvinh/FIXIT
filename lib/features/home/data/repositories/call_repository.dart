import 'package:appwrite/appwrite.dart';
import 'package:fixit/core/constants/app_constants.dart';
import '../../domain/models/call_model.dart';

class CallRepository {
  final Databases _databases;
  final Realtime _realtime;
  final String _databaseId;
  static const _collectionId = 'calls';

  CallRepository({
    required Databases databases,
    required Realtime realtime,
    String? databaseId,
  })  : _databases = databases,
        _realtime = realtime,
        _databaseId = databaseId ?? AppwriteConstants.databaseId;

  Future<CallModel> makeCall(CallModel call) async {
    final doc = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: ID.unique(),
      data: {
        'callerId': call.callerId,
        'receiverId': call.receiverId,
        'callerName': call.callerName,
        'receiverName': call.receiverName,
        'callerAvatar': call.callerAvatar,
        'receiverAvatar': call.receiverAvatar,
        'status': call.status.name,
        'createdAt': call.createdAt.toIso8601String(),
      },
      permissions: [
        Permission.read(Role.user(call.callerId)),
        Permission.read(Role.user(call.receiverId)),
        Permission.update(Role.user(call.callerId)),
        Permission.update(Role.user(call.receiverId)),
      ],
    );
    return CallModel.fromAppwrite(doc);
  }

  Future<void> updateCallStatus(String callId, CallStatus status) async {
    final now = DateTime.now().toIso8601String();
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _collectionId,
      documentId: callId,
      data: {
        'status': status.name,
        if (status == CallStatus.ongoing) 'startedAt': now,
        if (status == CallStatus.ended || status == CallStatus.rejected) 'endedAt': now,
      },
    );
  }

  Stream<CallModel?> watchCall(String callId) {
    return _realtime.subscribe([
      'databases.$_databaseId.collections.$_collectionId.documents.$callId'
    ]).stream.map((event) => CallModel.fromAppwrite(event.payload as dynamic));
  }

  Stream<CallModel?> listenForIncomingCalls(String userId) {
    return _realtime.subscribe([
      'databases.$_databaseId.collections.$_collectionId.documents'
    ]).stream.where((event) {
      final data = event.payload;
      return data['receiverId'] == userId && data['status'] == CallStatus.dialing.name;
    }).map((event) => CallModel.fromAppwrite(event.payload as dynamic));
  }
}
