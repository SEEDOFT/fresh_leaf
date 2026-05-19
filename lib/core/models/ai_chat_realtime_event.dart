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
    final normalizedPayload = _unwrapPayload(payload);
    final normalizedFullText = _readString(
      normalizedPayload,
      snakeKey: 'full_text',
      camelKey: 'fullText',
    );
    final normalizedError = formatToString(normalizedPayload['error']);

    return AiChatRealtimeEvent(
      eventType: eventType,
      sessionId: _readString(
        normalizedPayload,
        snakeKey: 'session_id',
        camelKey: 'sessionId',
      ),
      messageId: _readString(
        normalizedPayload,
        snakeKey: 'message_id',
        camelKey: 'messageId',
      ),
      role: formatToString(normalizedPayload['role']),
      timestamp: _readString(
        normalizedPayload,
        snakeKey: 'timestamp',
        camelKey: 'timeStamp',
      ),
      sequence: toInt(
        normalizedPayload['sequence'] ?? normalizedPayload['seq'],
      ),
      textChunk: _readString(
        normalizedPayload,
        snakeKey: 'text_chunk',
        camelKey: 'textChunk',
      ),
      fullText: normalizedError.isNotEmpty
          ? normalizedError
          : (normalizedFullText.isNotEmpty
                ? normalizedFullText
                : formatToString(
                    normalizedPayload['content'] ?? normalizedPayload['text'],
                  )),
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

Map<String, dynamic> _unwrapPayload(Map<String, dynamic> payload) {
  final dataValue = payload['data'];
  if (dataValue is Map<String, dynamic>) {
    return dataValue;
  }
  if (dataValue is Map) {
    return dataValue.map<String, dynamic>(
      (key, value) => MapEntry<String, dynamic>(key.toString(), value),
    );
  }
  return payload;
}

String _readString(
  Map<String, dynamic> payload, {
  required String snakeKey,
  required String camelKey,
}) {
  final snakeValue = formatToString(payload[snakeKey]);
  if (snakeValue.isNotEmpty) {
    return snakeValue;
  }
  return formatToString(payload[camelKey]);
}
