import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/ai_chat_session.dart';

void main() {
  group('AiChatSession', () {
    test('fromMap parses map correctly', () {
      final session = AiChatSession.fromMap(<String, dynamic>{
        'session_id': 'sess_001',
        'user_id': 'user_42',
        'channel_name': 'private-ai-session.sess_001',
      });

      expect(session.sessionId, 'sess_001');
      expect(session.userId, 'user_42');
      expect(session.channelName, 'private-ai-session.sess_001');
    });

    test('fromMap handles missing keys with empty strings', () {
      final session = AiChatSession.fromMap(<String, dynamic>{});
      expect(session.sessionId, '');
      expect(session.userId, '');
      expect(session.channelName, '');
    });

    test('fromMap converts non-string values to string', () {
      final session = AiChatSession.fromMap(<String, dynamic>{
        'session_id': 123,
        'user_id': true,
        'channel_name': null,
      });

      expect(session.sessionId, '123');
      expect(session.userId, 'true');
      expect(session.channelName, '');
    });
  });
}
