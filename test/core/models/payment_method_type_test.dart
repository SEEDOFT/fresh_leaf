import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/payment_method_type.dart';

void main() {
  group('PaymentMethodType', () {
    test('parses full map', () {
      final type = PaymentMethodType.fromMap(<String, dynamic>{
        'id': 1,
        'code': 'credit_card',
        'name': 'Credit Card',
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': '2026-06-01T11:00:00Z',
      });

      expect(type.id, 1);
      expect(type.code, 'credit_card');
      expect(type.name, 'Credit Card');
      expect(type.createdAt, isNotNull);
      expect(type.updatedAt, isNotNull);
    });

    test('handles null values', () {
      final type = PaymentMethodType.fromMap(<String, dynamic>{
        'id': null,
        'code': null,
        'name': null,
        'created_at': null,
        'updated_at': null,
      });

      expect(type.id, isNull);
      expect(type.code, '');
      expect(type.name, '');
      expect(type.createdAt, isNull);
      expect(type.updatedAt, isNull);
    });

    test('handles empty map', () {
      final type = PaymentMethodType.fromMap(<String, dynamic>{});

      expect(type.id, isNull);
      expect(type.code, '');
      expect(type.name, '');
    });

    test('toMap round-trip', () {
      final type = PaymentMethodType.fromMap(<String, dynamic>{
        'id': 2,
        'code': 'aba',
        'name': 'ABA Pay',
      });

      final map = type.toMap();
      expect(map['code'], 'aba');
      expect(map['id'], 2);
    });
  });
}
