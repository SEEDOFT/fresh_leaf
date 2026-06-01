import 'package:fresh_leaf/shared/helpers/helper.dart';

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.type,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatConversation.fromMap(Map<String, dynamic> map) {
    final source = (map['data'] is Map<String, dynamic>)
        ? map['data'] as Map<String, dynamic>
        : map;

    return ChatConversation(
      id: toInt(source['id']),
      type: formatToString(source['type']),
      status: formatToString(source['status']),
      createdAt: toNullableDateTime(source['created_at']),
      updatedAt: toNullableDateTime(source['updated_at']),
    );
  }

  final int id;
  final String type;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isOpen => status == 'open';
}
