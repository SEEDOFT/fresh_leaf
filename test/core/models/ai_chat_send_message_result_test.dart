import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/ai_chat_send_message_result.dart';

void main() {
  group('AiChatSendMessageResult', () {
    test('fromMap parses map correctly', () {
      final result = AiChatSendMessageResult.fromMap(<String, dynamic>{
        'session_id': 'sess_001',
        'user_message_id': 'msg_user_1',
        'ai_message_id': 'msg_ai_1',
        'status': 'queued',
      });

      expect(result.sessionId, 'sess_001');
      expect(result.userMessageId, 'msg_user_1');
      expect(result.assistantMessageId, 'msg_ai_1');
      expect(result.status, 'queued');
    });

    test('fromMap handles missing keys with empty strings', () {
      final result = AiChatSendMessageResult.fromMap(<String, dynamic>{});
      expect(result.sessionId, '');
      expect(result.userMessageId, '');
      expect(result.assistantMessageId, '');
      expect(result.status, '');
    });

    test('fromMap converts non-string values', () {
      final result = AiChatSendMessageResult.fromMap(<String, dynamic>{
        'session_id': 42,
        'user_message_id': null,
        'ai_message_id': true,
      });

      expect(result.sessionId, '42');
      expect(result.userMessageId, '');
      expect(result.assistantMessageId, 'true');
    });
  });
}
