import 'package:fresh_leaf/shared/helpers/helper.dart';

class Order {
  const Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: formatToString(map['id']),
      date: formatToString(map['date']),
      total: toDouble(map['total']),
      status: formatToString(map['status']),
      items: (map['items'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList(),
    );
  }

  final String id;
  final String date;
  final double total;
  final String status;
  final List<Map<String, dynamic>> items;

  Order copyWith({
    String? id,
    String? date,
    double? total,
    String? status,
    List<Map<String, dynamic>>? items,
  }) {
    return Order(
      id: id ?? this.id,
      date: date ?? this.date,
      total: total ?? this.total,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'total': total,
    'status': status,
    'items': items,
  };
}
