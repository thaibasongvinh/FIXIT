import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../../domain/models/saved_payment_method.dart';
import '../../domain/wallet_repository.dart';
import '../../domain/models/wallet_model.dart';

class AppwriteWalletRepositoryImpl implements WalletRepository {
  AppwriteWalletRepositoryImpl({
    required Databases databases,
    required Realtime realtime,
    required Functions functions,
    required String databaseId,
  })  : _db = databases,
        _realtime = realtime,
        _functions = functions,
        _dbId = databaseId;

  final Databases _db;
  final Realtime _realtime;
  final Functions _functions;
  final String _dbId;
  static const _walletCollId = 'wallets';
  static const _transCollId = 'transactions';
  static const _pmCollId = 'payment_methods';

  @override
  Future<WalletModel?> getWallet(String userId) async {
    try {
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _walletCollId,
        documentId: userId,
      );
      return WalletModel.fromAppwrite(doc);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<WalletModel?> watchWallet(String userId) async* {
    try {
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _walletCollId,
        documentId: userId,
      );
      yield WalletModel.fromAppwrite(doc);
    } catch (_) {
      yield null;
    }

    final subscription = _realtime.subscribe([
      'databases.$_dbId.collections.$_walletCollId.documents.$userId'
    ]);

    await for (final event in subscription.stream) {
      if (event.payload.isNotEmpty) {
        yield WalletModel.fromAppwrite(models.Document.fromMap(event.payload));
      }
    }
  }

  @override
  Stream<List<TransactionModel>> watchTransactions(String walletId) async* {
    final snap = await _db.listDocuments(
      databaseId: _dbId,
      collectionId: _transCollId,
      queries: [
        Query.equal('walletId', walletId),
        Query.orderDesc('createdAt'),
      ],
    );
    yield snap.documents.map((d) => TransactionModel.fromAppwrite(d)).toList();

    final subscription = _realtime.subscribe([
      'databases.$_dbId.collections.$_transCollId.documents'
    ]);

    await for (final event in subscription.stream) {
      if (event.payload['walletId'] == walletId) {
        final newSnap = await _db.listDocuments(
          databaseId: _dbId,
          collectionId: _transCollId,
          queries: [
            Query.equal('walletId', walletId),
            Query.orderDesc('createdAt'),
          ],
        );
        yield newSnap.documents.map((d) => TransactionModel.fromAppwrite(d)).toList();
      }
    }
  }

  @override
  Stream<List<SavedPaymentMethod>> watchPaymentMethods(String userId) {
    return Stream.fromFuture(_db.listDocuments(
      databaseId: _dbId,
      collectionId: _pmCollId,
      queries: [
        Query.equal('userId', userId),
        Query.orderDesc('createdAt'),
      ],
    )).map((snap) =>
        snap.documents.map((d) => SavedPaymentMethod(
          id: d.$id,
          type: SavedPaymentMethodType.card,
          label: d.data['label'] ?? '',
          maskedNumber: d.data['maskedNumber'] ?? '',
          holderName: d.data['holderName'] ?? '',
          expiryDate: d.data['expiryDate'] ?? '',
          isDefault: d.data['isDefault'] ?? false,
          isEnabled: d.data['isEnabled'] ?? true,
        )).toList());
  }

  @override
  Future<void> topUp(String userId, int amount, String method) async {
    try {
      await _functions.createExecution(
        functionId: 'secure-wallet-topup', 
        body: '{"userId": "$userId", "amount": $amount, "method": "$method"}',
      );
    } catch (e) {
      final wallet = await getWallet(userId);
      final newBalance = (wallet?.balance ?? 0) + amount;
      
      if (wallet == null) {
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: _walletCollId,
          documentId: userId,
          data: {
            'userId': userId, 
            'balance': newBalance, 
            'totalEarned': 0,
            'updatedAt': DateTime.now().toIso8601String()
          },
          permissions: [Permission.read(Role.user(userId))],
        );
      } else {
        await _db.updateDocument(
          databaseId: _dbId,
          collectionId: _walletCollId,
          documentId: userId,
          data: {'balance': newBalance, 'updatedAt': DateTime.now().toIso8601String()},
        );
      }

      // Log Transaction
      await _db.createDocument(
        databaseId: _dbId,
        collectionId: _transCollId,
        documentId: ID.unique(),
        data: {
          'walletId': userId,
          'amount': amount,
          'type': 'topup',
          'status': 'success',
          'description': 'Nạp tiền qua $method',
          'createdAt': DateTime.now().toIso8601String(),
        }
      );
    }
  }

  @override
  Future<void> pay(String userId, int amount, String description) async {
    try {
      await _functions.createExecution(
        functionId: 'secure-wallet-pay',
        body: '{"userId": "$userId", "amount": $amount, "description": "$description"}',
      );
    } catch (e) {
      final wallet = await getWallet(userId);
      if (wallet == null || wallet.balance < amount) throw Exception('Số dư không đủ');
      
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _walletCollId,
        documentId: userId,
        data: {'balance': wallet.balance - amount, 'updatedAt': DateTime.now().toIso8601String()},
      );

      // Log Transaction
      await _db.createDocument(
        databaseId: _dbId,
        collectionId: _transCollId,
        documentId: ID.unique(),
        data: {
          'walletId': userId,
          'amount': -amount,
          'type': 'payment',
          'status': 'success',
          'description': description,
          'createdAt': DateTime.now().toIso8601String(),
        }
      );
    }
  }

  Future<void> requestWithdrawal(String userId, int amount, Map<String, dynamic> bankInfo) async {
    final wallet = await getWallet(userId);
    if (wallet == null || wallet.balance < amount) throw Exception('Số dư không đủ để rút');

    // 1. Trừ tiền trong ví
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _walletCollId,
      documentId: userId,
      data: {'balance': wallet.balance - amount, 'updatedAt': DateTime.now().toIso8601String()},
    );

    // 2. Tạo record giao dịch rút tiền
    await _db.createDocument(
      databaseId: _dbId,
      collectionId: _transCollId,
      documentId: ID.unique(),
      data: {
        'walletId': userId,
        'amount': -amount,
        'type': 'withdrawal',
        'status': 'pending',
        'description': 'Yêu cầu rút tiền về ${bankInfo['bankName']}',
        'createdAt': DateTime.now().toIso8601String(),
      }
    );
  }

  @override
  Future<void> savePaymentMethod(String userId, SavedPaymentMethod method) async {
    await _db.createDocument(
      databaseId: _dbId,
      collectionId: _pmCollId,
      documentId: ID.unique(),
      data: {
        'type': method.type.name,
        'label': method.label,
        'maskedNumber': method.maskedNumber,
        'holderName': method.holderName,
        'expiryDate': method.expiryDate,
        'isDefault': method.isDefault,
        'isEnabled': method.isEnabled,
        'userId': userId,
        'createdAt': DateTime.now().toIso8601String(),
      },
      permissions: [Permission.read(Role.user(userId))],
    );
  }

  @override
  Future<void> setDefaultPaymentMethod(String userId, String methodId) async {}

  @override
  Future<String> createVNPayUrl(int amount, String? bookingId) async {
    final result = await _functions.createExecution(
      functionId: 'create-vnpay-url',
      body: '{"amount": $amount, "bookingId": "$bookingId"}',
    );
    return result.responseBody;
  }
}
