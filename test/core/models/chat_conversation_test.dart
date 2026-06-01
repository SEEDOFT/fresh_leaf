import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/chat_conversation.dart';

void main() {
  group('ChatConversation', () {
    test('parses stable vendor direct chat payload', () {
      final conversation = ChatConversation.fromMap(
        <String, dynamic>{
          'id': 12,
          'type': 'direct',
          'status': 'open',
          'other_participant': <String, dynamic>{
            'id': 7,
            'type': 'vendor',
            'full_name': 'Vendor Leaf',
            'business_name': 'Green Basket',
            'store_front_image': 'https://example.test/store.png',
            'is_verified': true,
          },
          'latest_message': <String, dynamic>{
            'id': 99,
            'sender_id': 7,
            'content': 'Fresh herbs are available.',
            'has_attachment': false,
            'created_at': '2026-06-01T10:00:00Z',
          },
          'unread_count': 3,
          'deep_link': 'freshleaf://support-chat?conversation_id=12',
          'created_at': '2026-06-01T09:00:00Z',
          'updated_at': '2026-06-01T10:00:00Z',
        },
      );

      expect(conversation.id, 12);
      expect(conversation.isDirect, isTrue);
      expect(conversation.displayTitle, 'Green Basket');
      expect(conversation.previewText, 'Fresh herbs are available.');
      expect(conversation.unreadCount, 3);
      expect(conversation.otherParticipant?.type, 'vendor');
      expect(conversation.otherParticipant?.isVerified, isTrue);
      expect(
        conversation.deepLink,
        'freshleaf://support-chat?conversation_id=12',
      );
    });

    test('keeps backward compatibility with raw conversation shape', () {
      final conversation = ChatConversation.fromMap(
        <String, dynamic>{
          'id': 14,
          'type': <String, dynamic>{'name': 'support'},
          'status': <String, dynamic>{'name': 'closed'},
          'created_at': '2026-06-01T09:00:00Z',
        },
      );

      expect(conversation.id, 14);
      expect(conversation.type, 'support');
      expect(conversation.status, 'closed');
      expect(conversation.isSupport, isTrue);
      expect(conversation.isOpen, isFalse);
    });
  });
}
