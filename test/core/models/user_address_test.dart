import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/user_address.dart';

void main() {
  group('UserAddress', () {
    test('parses full address map', () {
      final address = UserAddress.fromMap(<String, dynamic>{
        'id': 1,
        'label': 'Home',
        'recipient_name': 'John Doe',
        'phone': '012345678',
        'address_line_1': '123 Main St',
        'address_line_2': 'Apt 4',
        'city': 'Phnom Penh',
        'province': 'Phnom Penh',
        'postal_code': '12101',
        'lat': 11.5564,
        'long': 104.9282,
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': '2026-06-01T11:00:00Z',
      });

      expect(address.id, '1');
      expect(address.label, 'Home');
      expect(address.recipientName, 'John Doe');
      expect(address.phone, '012345678');
      expect(address.addressLine1, '123 Main St');
      expect(address.addressLine2, 'Apt 4');
      expect(address.city, 'Phnom Penh');
      expect(address.province, 'Phnom Penh');
      expect(address.postalCode, '12101');
      expect(address.lat, 11.5564);
      expect(address.long, 104.9282);
      expect(address.createdAt, isNotEmpty);
      expect(address.updatedAt, isNotEmpty);
    });

    test(
      'falls back to alternative keys (line1, line2, latitude, longitude)',
      () {
        final address = UserAddress.fromMap(<String, dynamic>{
          'id': 2,
          'label': 'Work',
          'recipient_name': 'Jane',
          'phone': '098765432',
          'line1': '456 Oak Ave',
          'line2': 'Suite 200',
          'city': 'Siem Reap',
          'province': 'Siem Reap',
          'postal_code': '17259',
          'latitude': 13.3633,
          'longitude': 103.8564,
        });

        expect(address.addressLine1, '456 Oak Ave');
        expect(address.addressLine2, 'Suite 200');
        expect(address.lat, 13.3633);
        expect(address.long, 103.8564);
      },
    );

    test('defaults label to Address when empty', () {
      final address = UserAddress.fromMap(<String, dynamic>{
        'id': 3,
        'label': '',
        'recipient_name': '',
        'phone': '',
        'address_line_1': '',
      });

      expect(address.label, 'Address');
    });

    test('line2 getter falls back to city, province, postalCode', () {
      final address = UserAddress.fromMap(<String, dynamic>{
        'id': 4,
        'label': '',
        'recipient_name': '',
        'phone': '',
        'address_line_1': '123 Main St',
        'city': 'Phnom Penh',
        'province': 'Phnom Penh',
        'postal_code': '12101',
      });

      expect(address.line2, 'Phnom Penh, Phnom Penh, 12101');
    });

    test('line2 getter returns addressLine2 when not empty', () {
      final address = UserAddress.fromMap(<String, dynamic>{
        'id': 5,
        'label': '',
        'recipient_name': '',
        'phone': '',
        'address_line_1': '123 Main St',
        'address_line_2': 'Apt 4',
      });

      expect(address.line2, 'Apt 4');
    });

    test('line1 and line2 getters provide backward compatibility', () {
      final address = UserAddress.fromMap(<String, dynamic>{
        'id': 1,
        'label': '',
        'recipient_name': '',
        'phone': '',
        'address_line_1': '123 Main St',
        'city': 'PP',
      });

      expect(address.line1, '123 Main St');
      expect(address.latitude, address.lat);
      expect(address.longitude, address.long);
    });

    test('toApiMap exports correct keys', () {
      final address = UserAddress.fromMap(<String, dynamic>{
        'id': 1,
        'label': 'Home',
        'recipient_name': 'John',
        'phone': '012345',
        'address_line_1': '123 St',
        'city': 'PP',
        'province': 'PP',
        'postal_code': '12101',
        'lat': 11.55,
        'long': 104.92,
      });

      final map = address.toApiMap();
      expect(map['label'], 'Home');
      expect(map['recipient_name'], 'John');
      expect(map['address_line_1'], '123 St');
      expect(map.containsKey('id'), isFalse);
    });

    test('copyWith overrides specified fields', () {
      final address = UserAddress.fromMap(<String, dynamic>{
        'id': 1,
        'label': 'Home',
        'recipient_name': 'John',
        'phone': '012',
        'address_line_1': '123 St',
      });

      final copy = address.copyWith(label: 'Office', phone: '099');
      expect(copy.label, 'Office');
      expect(copy.phone, '099');
      expect(copy.id, '1');
    });
  });
}
