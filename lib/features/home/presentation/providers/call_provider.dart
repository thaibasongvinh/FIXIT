import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/call_repository.dart';
import '../../domain/models/call_model.dart';

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final databases = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  final env = ref.watch(appEnvironmentProvider);
  return CallRepository(
    databases: databases,
    realtime: realtime,
    databaseId: env.appwriteDatabaseId,
  );
});

final currentCallProvider = StateProvider<CallModel?>((ref) => null);

final incomingCallProvider = StreamProvider<CallModel?>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return Stream.value(null);
  return ref.watch(callRepositoryProvider).listenForIncomingCalls(user.uid);
});

class CallNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final CallRepository _repo;

  CallNotifier(this._ref, this._repo) : super(const AsyncValue.data(null));

  Future<CallModel?> startCall({
    required String receiverId,
    required String receiverName,
    String? receiverAvatar,
  }) async {
    final user = _ref.read(currentUserProvider).valueOrNull;
    if (user == null) return null;

    final call = CallModel(
      id: '',
      callerId: user.uid,
      receiverId: receiverId,
      callerName: user.name,
      receiverName: receiverName,
      callerAvatar: user.avatar,
      receiverAvatar: receiverAvatar,
      status: CallStatus.dialing,
      createdAt: DateTime.now(),
    );

    try {
      final startedCall = await _repo.makeCall(call);
      _ref.read(currentCallProvider.notifier).state = startedCall;
      return startedCall;
    } catch (e) {
      return null;
    }
  }

  Future<void> acceptCall(String callId) async {
    await _repo.updateCallStatus(callId, CallStatus.ongoing);
  }

  Future<void> endCall(String callId) async {
    await _repo.updateCallStatus(callId, CallStatus.ended);
    _ref.read(currentCallProvider.notifier).state = null;
  }

  Future<void> rejectCall(String callId) async {
    await _repo.updateCallStatus(callId, CallStatus.rejected);
  }
}

final callNotifierProvider = StateNotifierProvider<CallNotifier, AsyncValue<void>>((ref) {
  return CallNotifier(ref, ref.watch(callRepositoryProvider));
});
