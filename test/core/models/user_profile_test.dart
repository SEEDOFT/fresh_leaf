import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('parses flat snake_case map', () {
      final profile = UserProfile.fromMap(<String, dynamic>{
        'id': 1,
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.test',
        'image': 'https://example.test/avatar.png',
        'phone_number': '123456789',
        'locale': 'km',
        'theme': 'light',
        'set_pin': true,
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': '2026-06-01T11:00:00Z',
      });

      expect(profile.id, 1);
      expect(profile.firstName, 'John');
      expect(profile.lastName, 'Doe');
      expect(profile.email, 'john@example.test');
      expect(profile.theme, 'light');
      expect(profile.setPin, isTrue);
      expect(profile.createdAt, isNotNull);
      expect(profile.updatedAt, isNotNull);
    });

    test('parses nested data key', () {
      final profile = UserProfile.fromMap(<String, dynamic>{
        'data': <String, dynamic>{
          'id': 2,
          'first_name': 'Jane',
          'last_name': 'Smith',
          'email': 'jane@example.test',
          'image': '',
          'phone_number': '',
          'locale': 'km',
          'theme': 'system',
          'set_pin': false,
        },
      });

      expect(profile.id, 2);
      expect(profile.firstName, 'Jane');
      expect(profile.lastName, 'Smith');
    });

    test('falls back to camelCase keys', () {
      final profile = UserProfile.fromMap(<String, dynamic>{
        'id': 3,
        'firstName': 'Camel',
        'lastName': 'Case',
        'email': 'camel@example.test',
        'image': '',
        'phoneNumber': '',
        'locale': 'en',
        'theme': 'dark',
        'setPin': true,
      });

      expect(profile.firstName, 'Camel');
      expect(profile.lastName, 'Case');
      expect(profile.theme, 'dark');
      expect(profile.setPin, isTrue);
    });

    test('parses setPin from nested profile.has_pin', () {
      final profile = UserProfile.fromMap(<String, dynamic>{
        'id': 4,
        'first_name': 'Pin',
        'last_name': 'User',
        'email': 'pin@example.test',
        'image': '',
        'phone_number': '',
        'locale': 'km',
        'theme': 'system',
        'profile': <String, dynamic>{'has_pin': true},
      });

      expect(profile.setPin, isTrue);
    });

    test('uses default locale and theme when missing', () {
      final profile = UserProfile.fromMap(<String, dynamic>{
        'id': 5,
        'first_name': 'Default',
        'last_name': 'User',
        'email': 'default@example.test',
        'image': '',
        'phone_number': '',
      });

      expect(profile.locale, 'km');
      expect(profile.theme, 'system');
    });

    test('converts toMap correctly', () {
      final profile = UserProfile.fromMap(<String, dynamic>{
        'id': 1,
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.test',
        'image': '',
        'phone_number': '123',
        'locale': 'en',
        'theme': 'light',
        'set_pin': true,
        'created_at': '2026-06-01T10:00:00Z',
        'updated_at': null,
      });

      final map = profile.toMap();
      expect(map['first_name'], 'John');
      expect(map['email'], 'john@example.test');
      expect(map['updated_at'], isNull);
    });

    test('copyWith overrides specified fields', () {
      final profile = UserProfile.fromMap(<String, dynamic>{
        'id': 1,
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.test',
        'image': '',
        'phone_number': '',
        'locale': 'km',
        'theme': 'system',
        'set_pin': false,
      });

      final copy = profile.copyWith(firstName: 'Jane', setPin: true);
      expect(copy.id, 1);
      expect(copy.firstName, 'Jane');
      expect(copy.lastName, 'Doe');
      expect(copy.setPin, isTrue);
    });
  });
}
