import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:appwrite/models.dart' as models;

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    required String id,
    required String userId,
    @Default(0) int balance,
    @Default(0) int totalEarned,
    String? bankAccount,
    DateTime? updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  factory WalletModel.fromAppwrite(models.Document doc) {
    final data = doc.data;
    return WalletModel.fromJson({
      ...data,
      'id': doc.$id,
      'userId': data['userId'] ?? doc.$id,
      'updatedAt': data['updatedAt'] ?? doc.$updatedAt,
    });
  }
}

enum TransactionType { topup, payment, refund, withdrawal }

enum TransactionStatus { pending, success, failed }

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String walletId,
    required int amount,
    required TransactionType type,
    required TransactionStatus status,
    required String description,
    required DateTime createdAt,
    String? paymentMethod,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  factory TransactionModel.fromAppwrite(models.Document doc) {
    final data = doc.data;
    return TransactionModel.fromJson({
      ...data,
      'id': doc.$id,
      'createdAt': data['createdAt'] ?? doc.$createdAt,
    });
  }
}
