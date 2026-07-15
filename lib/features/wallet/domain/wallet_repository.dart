import 'models/saved_payment_method.dart';
import 'models/wallet_model.dart';

abstract class WalletRepository {
  Future<WalletModel?> getWallet(String userId);
  Stream<WalletModel?> watchWallet(String userId);
  Stream<List<TransactionModel>> watchTransactions(String walletId);
  Stream<List<SavedPaymentMethod>> watchPaymentMethods(String userId);

  // For development (Gói Spark): Client-side balance update
  // In production, this must be handled by Appwrite Functions for security.
  Future<void> topUp(String userId, int amount, String method);
  Future<void> pay(String userId, int amount, String description);
  Future<void> savePaymentMethod(String userId, SavedPaymentMethod method);
  Future<void> setDefaultPaymentMethod(String userId, String methodId);

  // VNPay
  Future<String> createVNPayUrl(int amount, String? bookingId);
}
