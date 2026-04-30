import 'package:fresh_leaf/shared/helpers/helper.dart';

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.userId,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportTicket.fromMap(Map<String, dynamic> map) {
    final source = (map['data'] is Map<String, dynamic>)
        ? map['data'] as Map<String, dynamic>
        : map;

    return SupportTicket(
      id: toInt(source['id']),
      userId: toInt(source['user_id']),
      status: formatToString(source['status']),
      createdAt: toDateTime(source['created_at']),
      updatedAt: toDateTime(source['updated_at']),
    );
  }

  final int id;
  final int userId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isOpen => status == 'open';
}
