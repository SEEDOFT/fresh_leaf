import 'package:fresh_leaf/core/config/app_config.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.filePath,
    this.fileUrl,
    this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final source = (map['message'] is Map<String, dynamic>)
        ? map['message'] as Map<String, dynamic>
        : (map['data'] is Map<String, dynamic>)
            ? map['data'] as Map<String, dynamic>
            : map;

    final path = source['file_path'] as String?;
    final url = source['file_url'] as String?;

    return ChatMessage(
      id: toInt(source['id']),
      conversationId: toInt(source['conversation_id']),
      senderId: toInt(source['sender_id']),
      content: formatToString(source['content']),
      filePath: path,
      fileUrl: url ?? _resolveUrl(path),
      createdAt: toNullableDateTime(source['created_at']),
    );
  }

  static String? _resolveUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http') || path.startsWith('data:')) return path;
    if (path.startsWith('/')) return '${AppConfig.apiUrl}$path';
    return '${AppConfig.apiUrl}/storage/$path';
  }

  final int id;
  final int conversationId;
  final int senderId;
  final String content;
  final String? filePath;
  final String? fileUrl;
  final DateTime? createdAt;

  ChatMessage copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? content,
    String? filePath,
    String? fileUrl,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'conversation_id': conversationId,
    'sender_id': senderId,
    'content': content,
    'file_path': filePath,
    'file_url': fileUrl,
    'created_at': createdAt?.toIso8601String(),
  };
}
