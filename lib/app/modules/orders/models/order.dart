class Order {
  final String id;
  final String date;
  final double total;
  final String status;
  final List<Map<String, dynamic>> items;

  const Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'total': total,
      'status': status,
      'items': items,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      total: (map['total'] as num?)?.toDouble() ?? 0,
      status: map['status']?.toString() ?? '',
      items: (map['items'] as List? ?? const [])
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList(),
    );
  }
}
