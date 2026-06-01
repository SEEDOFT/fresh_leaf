import 'package:fresh_leaf/shared/helpers/helper.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.filePath,
    this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final source = (map['data'] is Map<String, dynamic>)
        ? map['data'] as Map<String, dynamic>
        : map;

    return ChatMessage(
      id: toInt(source['id']),
      conversationId: toInt(source['conversation_id']),
      senderId: toInt(source['sender_id']),
      content: formatToString(source['content']),
      filePath: source['file_path'] as String?,
      createdAt: toNullableDateTime(source['created_at']),
    );
  }

  final int id;
  final int conversationId;
  final int senderId;
  final String content;
  final String? filePath;
  final DateTime? createdAt;

  ChatMessage copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? content,
    String? filePath,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'conversation_id': conversationId,
    'sender_id': senderId,
    'content': content,
    'file_path': filePath,
    'created_at': createdAt?.toIso8601String(),
  };
}
