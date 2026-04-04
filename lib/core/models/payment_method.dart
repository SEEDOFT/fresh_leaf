import 'package:fresh_leaf/core/models/payment_method_status.dart';
import 'package:fresh_leaf/core/models/payment_method_type.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class PaymentMethod {
  const PaymentMethod({
    required this.cardNumber,
    required this.cvv,
    required this.paymentMethodTypeId,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardHolderName,
    required this.billingAddress,
    required this.billingCity,
    required this.billingState,
    required this.billingZipCode,
    this.id,
    this.label,
    this.paymentMethodType,
    this.paymentMethodStatusId,
    this.paymentMethodStatus,
    this.isDefault,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: toInt(map['id']),
      label: formatToString(map['label']),
      cardNumber: formatToString(map['card_number']),
      cvv: formatToString(map['cvv']),
      paymentMethodTypeId: toInt(map['payment_method_type_id']),
      paymentMethodType: PaymentMethodType.fromMap(
        map['payment_method_type'] as Map<String, dynamic>? ?? {},
      ),
      paymentMethodStatusId: toInt(map['payment_method_status_id']),
      paymentMethodStatus: PaymentMethodStatus.fromMap(
        map['payment_method_status'] as Map<String, dynamic>? ?? {},
      ),
      expiryMonth: toInt(map['expiry_month']),
      expiryYear: toInt(map['expiry_year']),
      cardHolderName: formatToString(map['card_holder_name']),
      billingAddress: formatToString(map['billing_address']),
      billingCity: formatToString(map['billing_city']),
      billingState: formatToString(map['billing_state']),
      billingZipCode: formatToString(map['billing_zip_code']),
      isDefault: toBool(map['is_default']),
    );
  }

  final int? id;
  final String? label;
  final String cvv;
  final int paymentMethodTypeId;
  final PaymentMethodType? paymentMethodType;
  final int? paymentMethodStatusId;
  final PaymentMethodStatus? paymentMethodStatus;
  final int expiryMonth;
  final int expiryYear;
  final String cardNumber;
  final String cardHolderName;
  final bool? isDefault;
  final String billingAddress;
  final String billingCity;
  final String billingState;
  final String billingZipCode;

  Map<String, dynamic> toMap() => {
    'id': id,
    'label': label,
    'cvv': cvv,
    'payment_method_type_id': paymentMethodTypeId,
    'payment_method_type': paymentMethodType?.toMap(),
    'payment_method_status_id': paymentMethodStatusId,
    'payment_method_status': paymentMethodStatus?.toMap(),
    'expiry_month': expiryMonth,
    'expiry_year': expiryYear,
    'card_number': cardNumber,
    'card_holder_name': cardHolderName,
    'billing_address': billingAddress,
    'billing_city': billingCity,
    'billing_state': billingState,
    'billing_zip_code': billingZipCode,
    'is_default': isDefault,
  };

  PaymentMethod copyWith({
    int? id,
    String? label,
    String? cvv,
    int? paymentMethodTypeId,
    PaymentMethodType? paymentMethodType,
    int? paymentMethodStatusId,
    PaymentMethodStatus? paymentMethodStatus,
    int? expiryMonth,
    int? expiryYear,
    String? cardNumber,
    String? cardHolderName,
    String? billingAddress,
    String? billingCity,
    String? billingState,
    String? billingZipCode,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      label: label ?? this.label,
      cvv: cvv ?? this.cvv,
      paymentMethodTypeId: paymentMethodTypeId ?? this.paymentMethodTypeId,
      paymentMethodType: paymentMethodType ?? this.paymentMethodType,
      paymentMethodStatusId:
          paymentMethodStatusId ?? this.paymentMethodStatusId,
      paymentMethodStatus: paymentMethodStatus ?? this.paymentMethodStatus,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      billingAddress: billingAddress ?? this.billingAddress,
      billingCity: billingCity ?? this.billingCity,
      billingState: billingState ?? this.billingState,
      billingZipCode: billingZipCode ?? this.billingZipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
