import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';

void main() {
  group('PaymentMethod', () {
    test('parses full map', () {
      final method = PaymentMethod.fromMap(<String, dynamic>{
        'id': 1,
        'label': 'My Visa',
        'card_number': '4111111111111111',
        'cvv': '123',
        'payment_method_type_id': 1,
        'payment_method_type': <String, dynamic>{
          'id': 1,
          'code': 'credit_card',
          'name': 'Credit Card',
        },
        'payment_method_status_id': 1,
        'payment_method_status': <String, dynamic>{
          'id': 1,
          'code': 'active',
          'name': 'Active',
        },
        'expiry_month': 12,
        'expiry_year': 2028,
        'card_holder_name': 'John Doe',
        'billing_address': '123 Main St',
        'billing_city': 'Phnom Penh',
        'billing_state': 'PP',
        'billing_zip_code': '12101',
        'is_default': true,
      });

      expect(method.id, 1);
      expect(method.label, 'My Visa');
      expect(method.cardNumber, '4111111111111111');
      expect(method.paymentMethodTypeId, 1);
      expect(method.paymentMethodType?.code, 'credit_card');
      expect(method.paymentMethodStatus?.code, 'active');
      expect(method.expiryMonth, 12);
      expect(method.expiryYear, 2028);
      expect(method.cardHolderName, 'John Doe');
      expect(method.isDefault, isTrue);
    });

    test('handles null optional fields', () {
      final method = PaymentMethod.fromMap(<String, dynamic>{
        'card_number': '',
        'cvv': '',
        'payment_method_type_id': 0,
        'expiry_month': 0,
        'expiry_year': 0,
        'card_holder_name': '',
        'billing_address': '',
        'billing_city': '',
        'billing_state': '',
        'billing_zip_code': '',
      });

      expect(method.id, 0);
      expect(method.label, '');
      expect(method.paymentMethodType, isNotNull);
      expect(method.paymentMethodType?.id, isNull);
      expect(method.isDefault, isFalse);
    });

    test('toMap round-trip', () {
      final method = PaymentMethod.fromMap(<String, dynamic>{
        'id': 1,
        'label': 'Card',
        'card_number': '4111',
        'cvv': '123',
        'payment_method_type_id': 1,
        'payment_method_type': <String, dynamic>{
          'id': 1,
          'code': 'credit_card',
          'name': 'Credit Card',
        },
        'payment_method_status_id': 1,
        'payment_method_status': <String, dynamic>{
          'id': 1,
          'code': 'active',
          'name': 'Active',
        },
        'expiry_month': 12,
        'expiry_year': 2028,
        'card_holder_name': 'John',
        'billing_address': '123 St',
        'billing_city': 'PP',
        'billing_state': 'PP',
        'billing_zip_code': '12101',
        'is_default': true,
      });

      final map = method.toMap();
      expect(map['card_number'], '4111');
      expect(map['is_default'], true);
      expect((map['payment_method_type'] as Map)['code'], 'credit_card');
    });

    test('copyWith overrides specified fields', () {
      final method = PaymentMethod.fromMap(<String, dynamic>{
        'card_number': '1',
        'cvv': '',
        'payment_method_type_id': 0,
        'expiry_month': 0,
        'expiry_year': 0,
        'card_holder_name': '',
        'billing_address': '',
        'billing_city': '',
        'billing_state': '',
        'billing_zip_code': '',
      });

      final copy = method.copyWith(
        cardNumber: '4111111111111111',
        cardHolderName: 'Jane',
        isDefault: true,
      );
      expect(copy.cardNumber, '4111111111111111');
      expect(copy.cardHolderName, 'Jane');
      expect(copy.isDefault, isTrue);
    });
  });
}
