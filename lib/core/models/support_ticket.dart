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
      statusId: (source['status'] as Map<String, dynamic>?)?['id'] as int? ?? 1,
      createdAt: toDateTime(source['created_at']),
      updatedAt: toDateTime(source['updated_at']),
    );
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
