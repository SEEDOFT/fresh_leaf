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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'total': total,
      'status': status,
      'items': items,
    };
  }
}
