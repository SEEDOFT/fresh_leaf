import 'package:fresh_leaf/shared/helpers/helper.dart';

final class AiChatEventType {
  AiChatEventType._();

  static const messageStarted = 'AiMessageStarted';
  static const messageChunk = 'AiMessageChunk';
  static const messageCompleted = 'AiMessageCompleted';
  static const messageFailed = 'AiMessageFailed';
}

class AiChatRealtimeEvent {
  const AiChatRealtimeEvent({
    required this.eventType,
    required this.sessionId,
    required this.messageId,
    required this.role,
    required this.timestamp,
    required this.sequence,
    required this.textChunk,
    required this.fullText,
  });

  factory AiChatRealtimeEvent.fromPayload({
    required String eventType,
    required Map<String, dynamic> payload,
  }) {
    return AiChatRealtimeEvent(
      eventType: eventType,
      sessionId: formatToString(payload['session_id']),
      messageId: formatToString(payload['message_id']),
      role: formatToString(payload['role']),
      timestamp: formatToString(payload['timestamp']),
      sequence: toInt(payload['sequence']),
      textChunk: formatToString(payload['text_chunk']),
      fullText: formatToString(payload['full_text']),
    );
  }

  final String eventType;
  final String sessionId;
  final String messageId;
  final String role;
  final String timestamp;
  final int sequence;
  final String textChunk;
  final String fullText;

  bool get isStarted => eventType == AiChatEventType.messageStarted;
  bool get isChunk => eventType == AiChatEventType.messageChunk;
  bool get isCompleted => eventType == AiChatEventType.messageCompleted;
  bool get isFailed => eventType == AiChatEventType.messageFailed;
}
