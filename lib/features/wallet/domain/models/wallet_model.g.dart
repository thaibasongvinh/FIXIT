// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletModelImpl _$$WalletModelImplFromJson(Map<String, dynamic> json) =>
    _$WalletModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      totalEarned: (json['totalEarned'] as num?)?.toInt() ?? 0,
      bankAccount: json['bankAccount'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WalletModelImplToJson(_$WalletModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'balance': instance.balance,
      'totalEarned': instance.totalEarned,
      'bankAccount': instance.bankAccount,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      amount: (json['amount'] as num).toInt(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      paymentMethod: json['paymentMethod'] as String?,
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'walletId': instance.walletId,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.topup: 'topup',
  TransactionType.payment: 'payment',
  TransactionType.refund: 'refund',
  TransactionType.withdrawal: 'withdrawal',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.success: 'success',
  TransactionStatus.failed: 'failed',
};
