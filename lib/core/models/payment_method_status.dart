import 'package:fresh_leaf/shared/helpers/helper.dart';

class PaymentMethodStatus {
  const PaymentMethodStatus({
    required this.id,
    required this.code,
    required this.name,
  });

  factory PaymentMethodStatus.fromMap(Map<String, dynamic> map) {
    return PaymentMethodStatus(
      id: toInt(map['id']),
      code: formatToString(map['code']),
      name: formatToString(map['name']),
    );
  }

  final int id;
  final String code;
  final String name;

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'name': name,
  };

  PaymentMethodStatus copyWith({
    int? id,
    String? code,
    String? name,
  }) {
    return PaymentMethodStatus(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}
