import 'package:fresh_leaf/shared/helpers/helper.dart';

class SupportMessage {
  const SupportMessage({
    required this.id,
    required this.supportTicketId,
    required this.senderType,
    required this.senderId,
    required this.message,
    this.filePath,
    this.createdAt,
  });

  factory SupportMessage.fromMap(Map<String, dynamic> map) {
    final source = (map['data'] is Map<String, dynamic>)
        ? map['data'] as Map<String, dynamic>
        : map;

    return SupportMessage(
      id: toInt(source['id']),
      supportTicketId: toInt(source['support_ticket_id']),
      senderType: formatToString(source['sender_type']),
      senderId: toInt(source['sender_id']),
      message: formatToString(source['message']),
      filePath: source['file_path'] as String?,
      createdAt: toDateTime(source['created_at']),
    );
  }

  final int id;
  final int supportTicketId;
  final String senderType;
  final int senderId;
  final String message;
  final String? filePath;
  final DateTime? createdAt;

  bool get isAdmin => senderType == 'admin';
  bool get isUser => senderType == 'user';
}
