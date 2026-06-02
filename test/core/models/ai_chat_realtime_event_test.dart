import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/ai_chat_realtime_event.dart';

void main() {
  group('AiChatEventType', () {
    test('constants are correct strings', () {
      expect(AiChatEventType.messageStarted, 'AiMessageStarted');
      expect(AiChatEventType.messageChunk, 'AiMessageChunk');
      expect(AiChatEventType.messageCompleted, 'AiMessageCompleted');
      expect(AiChatEventType.messageFailed, 'AiMessageFailed');
    });
  });

  group('AiChatRealtimeEvent', () {
    test('fromPayload parses snake_case payload correctly', () {
      final event = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageChunk,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'session_id': 'sess_001',
            'message_id': 'msg_001',
            'role': 'assistant',
            'timestamp': '2026-06-14T12:00:00Z',
            'sequence': 1,
            'text_chunk': 'Hello',
            'full_text': 'Hello world',
          },
        },
      );

      expect(event.eventType, 'AiMessageChunk');
      expect(event.sessionId, 'sess_001');
      expect(event.messageId, 'msg_001');
      expect(event.role, 'assistant');
      expect(event.timestamp, '2026-06-14T12:00:00Z');
      expect(event.sequence, 1);
      expect(event.textChunk, 'Hello');
      expect(event.fullText, 'Hello world');
    });

    test('fromPayload handles camelCase payload', () {
      final event = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageCompleted,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'sessionId': 'sess_002',
            'messageId': 'msg_002',
            'role': 'assistant',
            'timeStamp': '2026-06-14T12:01:00Z',
            'sequence': 2,
            'textChunk': '',
            'fullText': 'Response complete',
          },
        },
      );

      expect(event.sessionId, 'sess_002');
      expect(event.messageId, 'msg_002');
      expect(event.fullText, 'Response complete');
    });

    test('fromPayload falls back to content/text for fullText', () {
      final contentEvent = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageCompleted,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'session_id': 'sess_003',
            'message_id': 'msg_003',
            'role': 'assistant',
            'timestamp': '',
            'sequence': 3,
            'text_chunk': '',
            'content': 'Content fallback',
          },
        },
      );
      expect(contentEvent.fullText, 'Content fallback');

      final textEvent = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageCompleted,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'session_id': 'sess_004',
            'message_id': 'msg_004',
            'role': 'assistant',
            'timestamp': '',
            'sequence': 4,
            'text_chunk': '',
            'text': 'Text fallback',
          },
        },
      );
      expect(textEvent.fullText, 'Text fallback');
    });

    test('fromPayload uses error for fullText when present', () {
      final event = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageFailed,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'session_id': 'sess_005',
            'message_id': 'msg_005',
            'role': 'assistant',
            'timestamp': '',
            'sequence': 5,
            'text_chunk': '',
            'full_text': '',
            'error': 'Something went wrong',
          },
        },
      );
      expect(event.fullText, 'Something went wrong');
    });

    test('fromPayload unwraps data key', () {
      final event = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageStarted,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'session_id': 'sess_006',
            'message_id': 'msg_006',
            'role': 'user',
            'timestamp': '2026-06-14T12:02:00Z',
            'sequence': 6,
            'text_chunk': '',
            'full_text': '',
          },
        },
      );
      expect(event.sessionId, 'sess_006');
    });

    test('fromPayload handles string sequence via seq key', () {
      final event = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageChunk,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'session_id': 'sess_007',
            'message_id': 'msg_007',
            'role': 'assistant',
            'timestamp': '',
            'seq': '7',
            'text_chunk': 'chunk',
          },
        },
      );
      expect(event.sequence, 7);
    });

    test('fromPayload handles nested data key that is already Map<String, dynamic>', () {
      final event = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageCompleted,
        payload: <String, dynamic>{
          'data': <String, dynamic>{
            'session_id': 'sess_008',
            'message_id': 'msg_008',
            'role': 'assistant',
            'timestamp': '2026-06-14T12:03:00Z',
            'sequence': 8,
            'text_chunk': '',
            'full_text': 'Final message',
          },
        },
      );
      expect(event.sequence, 8);
      expect(event.fullText, 'Final message');
    });

    test('getter booleans return correct values', () {
      final started = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageStarted,
        payload: <String, dynamic>{'data': <String, dynamic>{'session_id': '', 'message_id': '', 'role': '', 'timestamp': '', 'sequence': 0, 'text_chunk': ''}},
      );
      expect(started.isStarted, isTrue);
      expect(started.isChunk, isFalse);
      expect(started.isCompleted, isFalse);
      expect(started.isFailed, isFalse);

      final chunk = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageChunk,
        payload: <String, dynamic>{'data': <String, dynamic>{'session_id': '', 'message_id': '', 'role': '', 'timestamp': '', 'sequence': 0, 'text_chunk': ''}},
      );
      expect(chunk.isStarted, isFalse);
      expect(chunk.isChunk, isTrue);

      final completed = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageCompleted,
        payload: <String, dynamic>{'data': <String, dynamic>{'session_id': '', 'message_id': '', 'role': '', 'timestamp': '', 'sequence': 0, 'text_chunk': ''}},
      );
      expect(completed.isCompleted, isTrue);

      final failed = AiChatRealtimeEvent.fromPayload(
        eventType: AiChatEventType.messageFailed,
        payload: <String, dynamic>{'data': <String, dynamic>{'session_id': '', 'message_id': '', 'role': '', 'timestamp': '', 'sequence': 0, 'text_chunk': ''}},
      );
      expect(failed.isFailed, isTrue);
    });
  });
}
