import 'package:fresh_leaf/shared/helpers/helper.dart';

class PaymentMethodType {
  PaymentMethodType({
    this.id,
    this.code,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethodType.fromMap(Map<String, dynamic> map) {
    return PaymentMethodType(
      id: _parseNullableInt(map['id']),
      code: formatToString(map['code']),
      name: formatToString(map['name']),
      createdAt: _parseNullableDateTime(map['created_at']),
      updatedAt: _parseNullableDateTime(map['updated_at']),
    );
  }

  final int? id;
  final String? code;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'name': name,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  static DateTime? _parseNullableDateTime(dynamic value) {
    return toNullableDateTime(value);
  }

  static int? _parseNullableInt(dynamic value) {
    final raw = formatToString(value);
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }
}
