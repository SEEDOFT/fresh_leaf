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
      createdAt: toNullableDateTime(source['created_at']),
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

  SupportMessage copyWith({
    int? id,
    int? supportTicketId,
    String? senderType,
    int? senderId,
    String? message,
    String? filePath,
    DateTime? createdAt,
  }) {
    return SupportMessage(
      id: id ?? this.id,
      supportTicketId: supportTicketId ?? this.supportTicketId,
      senderType: senderType ?? this.senderType,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'support_ticket_id': supportTicketId,
    'sender_type': senderType,
    'sender_id': senderId,
    'message': message,
    'file_path': filePath,
    'created_at': createdAt?.toIso8601String(),
  };
}
