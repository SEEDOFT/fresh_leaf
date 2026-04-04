import 'package:fresh_leaf/shared/helpers/helper.dart';

class PaymentMethodType {
  PaymentMethodType({
    this.id,
    this.code,
    this.name,
  });

  factory PaymentMethodType.fromMap(Map<String, dynamic> map) {
    return PaymentMethodType(
      id: toInt(map['id']),
      code: formatToString(map['code']),
      name: formatToString(map['name']),
    );
  }

  final int? id;
  final String? code;
  final String? name;

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'name': name,
  };
}
