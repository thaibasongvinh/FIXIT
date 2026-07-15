import 'dart:io';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/verification_repository.dart';

part 'verification_provider.g.dart';

@riverpod
class VerificationNotifier extends _$VerificationNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> submitIdentity({
    required String identityNumber,
    required File frontImage,
    required File backImage,
  }) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      await ref.read(verificationRepositoryProvider).submitIdentityVerification(
        userId: user.uid,
        identityNumber: identityNumber,
        frontImage: frontImage,
        backImage: backImage,
      );
      
      // Invalidate current user to refresh the status in UI
      ref.invalidate(currentUserProvider);
    });
  }
}
