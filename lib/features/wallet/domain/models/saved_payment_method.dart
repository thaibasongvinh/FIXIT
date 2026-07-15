enum SavedPaymentMethodType {
  card,
  bankAccount,
  paypal,
  wallet,
}

class SavedPaymentMethod {
  const SavedPaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.maskedNumber,
    required this.holderName,
    required this.expiryDate,
    required this.isDefault,
    required this.isEnabled,
    this.createdAt,
  });

  final String id;
  final SavedPaymentMethodType type;
  final String label;
  final String maskedNumber;
  final String holderName;
  final String expiryDate;
  final bool isDefault;
  final bool isEnabled;
  final DateTime? createdAt;

  String get subtitle {
    if (maskedNumber.isNotEmpty && expiryDate.isNotEmpty) {
      return '$maskedNumber  •  Exp $expiryDate';
    }
    if (maskedNumber.isNotEmpty) {
      return maskedNumber;
    }
    return holderName;
  }
}
