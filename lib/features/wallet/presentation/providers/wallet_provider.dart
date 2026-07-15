import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/features/wallet/data/repositories/appwrite_wallet_repository_impl.dart';
import '../../domain/models/saved_payment_method.dart';
import '../../domain/models/wallet_model.dart';
import '../../domain/wallet_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'wallet_provider.g.dart';

@riverpod
WalletRepository walletRepository(Ref ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  final functions = ref.watch(appwriteFunctionsProvider);
  final env = ref.watch(appEnvironmentProvider);
  return AppwriteWalletRepositoryImpl(
    databases: db,
    realtime: realtime,
    functions: functions,
    databaseId: env.appwriteDatabaseId,
  );
}

@riverpod
Stream<WalletModel?> userWallet(Ref ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(null);
  return ref.watch(walletRepositoryProvider).watchWallet(user.$id);
}

@riverpod
Stream<List<TransactionModel>> walletTransactions(Ref ref, String walletId) {
  return ref.watch(walletRepositoryProvider).watchTransactions(walletId);
}

final userPaymentMethodsProvider = StreamProvider<List<SavedPaymentMethod>>(
  (ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) {
      return Stream.value(const <SavedPaymentMethod>[]);
    }
    return ref.watch(walletRepositoryProvider).watchPaymentMethods(user.$id);
  },
);

@riverpod
class WalletNotifier extends _$WalletNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> topUp(int amount, String method) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(walletRepositoryProvider).topUp(user.$id, amount, method));
  }

  Future<void> pay(int amount, String description) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(walletRepositoryProvider).pay(user.$id, amount, description));
  }

  Future<void> requestWithdrawal(int amount, Map<String, dynamic> bankInfo) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        (ref.read(walletRepositoryProvider) as AppwriteWalletRepositoryImpl)
            .requestWithdrawal(user.$id, amount, bankInfo));
  }

  Future<String> createVNPayUrl(int amount) async {
    return ref.read(walletRepositoryProvider).createVNPayUrl(amount, null);
  }

  Future<void> savePaymentMethod({
    required SavedPaymentMethodType type,
    required String label,
    required String maskedNumber,
    required String holderName,
    required String expiryDate,
    bool isDefault = true,
  }) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      throw Exception('Vui lòng đăng nhập để lưu phương thức thanh toán');
    }

    final method = SavedPaymentMethod(
      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      label: label,
      maskedNumber: maskedNumber,
      holderName: holderName,
      expiryDate: expiryDate,
      isDefault: isDefault,
      isEnabled: true,
      createdAt: DateTime.now(),
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(walletRepositoryProvider).savePaymentMethod(user.$id, method));
  }

  Future<void> setDefaultPaymentMethod(String methodId) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      throw Exception('Vui lòng đăng nhập để chọn phương thức thanh toán');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(walletRepositoryProvider)
        .setDefaultPaymentMethod(user.$id, methodId));
  }
}
