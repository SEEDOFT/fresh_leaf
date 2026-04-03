import 'package:fresh_leaf/shared/helpers/helper.dart';

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.type,
    required this.expiryMonth,
    required this.expiryYear,
    required this.holderName,
    required this.isDefault,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: formatToString(map['id']),
      brand: formatToString(map['brand']),
      last4: formatToString(map['last4']),
      type: formatToString(map['payment_type_id']),
      expiryMonth: toInt(map['expiry_month']),
      expiryYear: toInt(map['expiry_year']),
      holderName: formatToString(map['holder_name']),
      isDefault: toBool(map['is_default']),
    );
  }

  final String id;
  final String brand;
  final String last4;
  final String type;
  final int expiryMonth;
  final int expiryYear;
  final String holderName;
  final bool isDefault;

  Map<String, dynamic> toMap() => {
    'id': id,
    'brand': brand,
    'last4': last4,
    'type': type,
    'expiry_month': expiryMonth,
    'expiry_year': expiryYear,
    'holder_name': holderName,
    'is_default': isDefault,
  };

  PaymentMethod copyWith({
    String? id,
    String? brand,
    String? last4,
    String? type,
    int? expiryMonth,
    int? expiryYear,
    String? holderName,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      type: type ?? this.type,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      holderName: holderName ?? this.holderName,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
