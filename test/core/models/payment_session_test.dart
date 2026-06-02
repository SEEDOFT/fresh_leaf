import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/payment_session.dart';

void main() {
  group('PaymentSession', () {
    test('parses full map with session_id', () {
      final session = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'sess_001',
        'status': <String, dynamic>{'id': 2},
        'redirect_url': 'https://checkout.test/pay',
        'qr_payload': '000201010212...',
        'qr_image_url': 'https://example.test/qr.png',
        'expires_at': '2026-06-02T10:00:00Z',
      });

      expect(session.sessionId, 'sess_001');
      expect(session.statusId, 2);
      expect(session.isPaid, isTrue);
      expect(session.redirectUrl, 'https://checkout.test/pay');
      expect(session.qrPayload, '000201010212...');
      expect(session.qrImageUrl, 'https://example.test/qr.png');
      expect(session.expiresAt, isNotNull);
    });

    test('falls back to id when session_id is absent', () {
      final session = PaymentSession.fromMap(<String, dynamic>{
        'id': 'fallback_id',
        'status': <String, dynamic>{'id': 1},
      });

      expect(session.sessionId, 'fallback_id');
      expect(session.statusId, 1);
      expect(session.isPaid, isFalse);
    });

    test('uses default status id 1 when status map is missing', () {
      final session = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'sess_003',
      });

      expect(session.statusId, 1);
      expect(session.isPaid, isFalse);
    });

    test('handles null optional fields', () {
      final session = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'sess_004',
        'redirect_url': null,
        'qr_payload': null,
        'qr_image_url': null,
        'expires_at': null,
      });

      expect(session.redirectUrl, isNull);
      expect(session.qrPayload, isNull);
      expect(session.qrImageUrl, isNull);
      expect(session.expiresAt, isNull);
    });

    test('toMap round-trip', () {
      final session = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'sess_005',
        'status': <String, dynamic>{'id': 3},
      });

      final map = session.toMap();
      expect(map['session_id'], 'sess_005');
      expect(map['status_id'], 3);
    });

    test('status labels map correctly', () {
      final pending = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'p',
      });
      expect(pending.status, 'payment_pending');

      final paid = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'c',
        'status': <String, dynamic>{'id': 2},
      });
      expect(paid.status, 'payment_completed');

      final failed = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'f',
        'status': <String, dynamic>{'id': 3},
      });
      expect(failed.status, 'payment_failed');

      final refunded = PaymentSession.fromMap(<String, dynamic>{
        'session_id': 'r',
        'status': <String, dynamic>{'id': 4},
      });
      expect(refunded.status, 'payment_refunded');
    });
  });
}
