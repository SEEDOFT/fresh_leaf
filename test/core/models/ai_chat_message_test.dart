import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/ai_chat_message.dart';

void main() {
  group('AiChatMessage', () {
    test('fromMap parses map correctly', () {
      final msg = AiChatMessage.fromMap(<String, dynamic>{
        'text': 'Hello',
        'isUser': true,
        'isStreaming': false,
        'sessionId': 'sess_001',
        'messageId': 'msg_001',
        'sequence': 1,
        'status': 'done',
      });

      expect(msg.text, 'Hello');
      expect(msg.isUser, isTrue);
      expect(msg.isStreaming, isFalse);
      expect(msg.sessionId, 'sess_001');
      expect(msg.messageId, 'msg_001');
      expect(msg.sequence, 1);
      expect(msg.status, 'done');
    });

    test('fromMap handles missing optional fields', () {
      final msg = AiChatMessage.fromMap(<String, dynamic>{
        'text': '',
        'isUser': null,
      });

      expect(msg.text, '');
      expect(msg.isUser, isFalse);
      expect(msg.isStreaming, isFalse);
      expect(msg.sessionId, '');
      expect(msg.messageId, '');
      expect(msg.sequence, isNull);
      expect(msg.status, 'done');
    });

    test('fromMap parses numeric values', () {
      final msg = AiChatMessage.fromMap(<String, dynamic>{
        'text': 'Hi',
        'isUser': 1,
        'isStreaming': 0,
        'sequence': '3',
      });

      expect(msg.text, 'Hi');
      expect(msg.isUser, isTrue);
      expect(msg.isStreaming, isFalse);
      expect(msg.sequence, 3);
    });

    test('toMap returns correct map', () {
      final msg = AiChatMessage(
        text: 'Hello',
        isUser: true,
        isStreaming: false,
        sessionId: 'sess_001',
        messageId: 'msg_001',
        sequence: 1,
        status: 'done',
      );

      final map = msg.toMap();
      expect(map['text'], 'Hello');
      expect(map['isUser'], true);
      expect(map['isStreaming'], false);
      expect(map['sessionId'], 'sess_001');
      expect(map['messageId'], 'msg_001');
      expect(map['sequence'], 1);
      expect(map['status'], 'done');
    });

    test('copyWith overrides specified fields', () {
      final original = AiChatMessage(
        text: 'Hello',
        isUser: true,
        isStreaming: false,
        sessionId: 'sess_001',
        messageId: 'msg_001',
        sequence: 1,
        status: 'done',
      );

      final copy = original.copyWith(
        text: 'Updated',
        isUser: false,
        sequence: 2,
      );

      expect(copy.text, 'Updated');
      expect(copy.isUser, isFalse);
      expect(copy.isStreaming, isFalse);
      expect(copy.sessionId, 'sess_001');
      expect(copy.messageId, 'msg_001');
      expect(copy.sequence, 2);
      expect(copy.status, 'done');
    });

    test('copyWith with no arguments returns identical copy', () {
      final original = AiChatMessage(
        text: 'Hello',
        isUser: true,
        isStreaming: true,
      );

      final copy = original.copyWith();
      expect(copy.text, 'Hello');
      expect(copy.isUser, isTrue);
      expect(copy.isStreaming, isTrue);
    });

    test('fromMap-toMap roundtrip preserves values', () {
      final original = AiChatMessage.fromMap(<String, dynamic>{
        'text': 'Roundtrip test',
        'isUser': true,
        'isStreaming': false,
        'sessionId': 'sess_rt',
        'messageId': 'msg_rt',
        'sequence': 5,
        'status': 'sent',
      });

      final map = original.toMap();
      final restored = AiChatMessage.fromMap(map);

      expect(restored.text, original.text);
      expect(restored.isUser, original.isUser);
      expect(restored.isStreaming, original.isStreaming);
      expect(restored.sessionId, original.sessionId);
      expect(restored.messageId, original.messageId);
      expect(restored.sequence, original.sequence);
      expect(restored.status, original.status);
    });
  });
}
