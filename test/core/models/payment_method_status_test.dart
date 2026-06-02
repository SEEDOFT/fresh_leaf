import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/payment_method_status.dart';

void main() {
  group('PaymentMethodStatus', () {
    test('parses from map', () {
      final status = PaymentMethodStatus.fromMap(<String, dynamic>{
        'id': 1,
        'code': 'active',
        'name': 'Active',
      });

      expect(status.id, 1);
      expect(status.code, 'active');
      expect(status.name, 'Active');
    });

    test('handles empty values', () {
      final status = PaymentMethodStatus.fromMap(<String, dynamic>{
        'id': null,
        'code': null,
        'name': null,
      });

      expect(status.id, 0);
      expect(status.code, '');
      expect(status.name, '');
    });

    test('toMap and copyWith round-trip', () {
      final status = PaymentMethodStatus.fromMap(<String, dynamic>{
        'id': 2,
        'code': 'expired',
        'name': 'Expired',
      });

      final map = status.toMap();
      expect(map['code'], 'expired');

      final copy = status.copyWith(name: 'Inactive');
      expect(copy.name, 'Inactive');
      expect(copy.id, 2);
    });
  });
}
