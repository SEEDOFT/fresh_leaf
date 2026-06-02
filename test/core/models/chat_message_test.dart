import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/chat_message.dart';

void main() {
  group('ChatMessage', () {
    test('parses from flat map', () {
      final message = ChatMessage.fromMap(<String, dynamic>{
        'id': 1,
        'conversation_id': 10,
        'sender_id': 5,
        'content': 'Hello, is this available?',
        'file_path': 'https://example.test/file.pdf',
        'created_at': '2026-06-01T10:00:00Z',
      });

      expect(message.id, 1);
      expect(message.conversationId, 10);
      expect(message.senderId, 5);
      expect(message.content, 'Hello, is this available?');
      expect(message.filePath, 'https://example.test/file.pdf');
      expect(message.createdAt, isNotNull);
    });

    test('parses from nested data key', () {
      final message = ChatMessage.fromMap(<String, dynamic>{
        'data': <String, dynamic>{
          'id': 2,
          'conversation_id': 10,
          'sender_id': 5,
          'content': 'Yes it is!',
          'created_at': '2026-06-01T11:00:00Z',
        },
      });

      expect(message.id, 2);
      expect(message.content, 'Yes it is!');
    });

    test('handles null values', () {
      final message = ChatMessage.fromMap(<String, dynamic>{
        'id': null,
        'conversation_id': null,
        'sender_id': null,
        'content': null,
        'file_path': null,
        'created_at': null,
      });

      expect(message.id, 0);
      expect(message.conversationId, 0);
      expect(message.senderId, 0);
      expect(message.content, '');
      expect(message.filePath, isNull);
      expect(message.createdAt, isNull);
    });

    test('toMap round-trip', () {
      final message = ChatMessage.fromMap(<String, dynamic>{
        'id': 1,
        'conversation_id': 10,
        'sender_id': 5,
        'content': 'Hi!',
      });

      final map = message.toMap();
      expect(map['id'], 1);
      expect(map['conversation_id'], 10);
      expect(map['content'], 'Hi!');
    });

    test('copyWith overrides specified fields', () {
      final message = ChatMessage.fromMap(<String, dynamic>{
        'id': 1,
        'conversation_id': 10,
        'sender_id': 5,
        'content': 'Original',
      });

      final copy = message.copyWith(content: 'Updated');
      expect(copy.content, 'Updated');
      expect(copy.id, 1);
    });
  });
}
