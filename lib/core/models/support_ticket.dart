import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class SupportTicket {
  const SupportTicket({
    required this.id,
    required this.userId,
    required this.statusId,
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
      statusId: _parseStatusId(source['status']),
      createdAt: toNullableDateTime(source['created_at']),
      updatedAt: toNullableDateTime(source['updated_at']),
    );
  }

  static int _parseStatusId(dynamic status) {
    if (status is Map<String, dynamic>) {
      return status['id'] as int? ?? 1;
    }
    if (status is int) return status;
    if (status is String) {
      return switch (status.toLowerCase()) {
        'open' => 1,
        'in_progress' => 2,
        'resolved' => 3,
        'closed' => 4,
        _ => 1,
      };
    }
    return 1;
  }

  final int id;
  final int userId;
  final int statusId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isOpen => statusId == 1;

  String get status {
    return switch (statusId) {
      1 => 'ticket_open'.tr,
      2 => 'ticket_in_progress'.tr,
      3 => 'ticket_resolved'.tr,
      4 => 'ticket_closed'.tr,
      _ => 'ticket_open'.tr,
    };
  }
}
