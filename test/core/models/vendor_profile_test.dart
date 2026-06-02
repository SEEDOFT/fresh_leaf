import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/vendor_profile.dart';

void main() {
  group('VendorProfile', () {
    test('parses full vendor map', () {
      final vendor = VendorProfile.fromMap(<String, dynamic>{
        'id': 1,
        'name': 'John',
        'email': 'john@farm.test',
        'phone_number': '012345678',
        'business_name': 'Green Basket',
        'contact_phone': '098765432',
        'village': 'Village 1',
        'commune': 'Commune A',
        'district': 'District X',
        'province': 'Phnom Penh',
        'address': '123 Farm Road',
        'shop_description': 'Fresh organic produce',
        'store_front_image': 'https://example.test/store.png',
        'opening_time': '06:00',
        'closing_time': '18:00',
        'is_open': true,
        'is_verified': true,
        'product_count': 42,
      });

      expect(vendor.id, 1);
      expect(vendor.name, 'John');
      expect(vendor.email, 'john@farm.test');
      expect(vendor.phoneNumber, '012345678');
      expect(vendor.businessName, 'Green Basket');
      expect(vendor.displayName, 'Green Basket');
      expect(vendor.isOpen, isTrue);
      expect(vendor.isVerified, isTrue);
      expect(vendor.productCount, 42);
    });

    test('displayName falls back to name when businessName is null', () {
      final vendor = VendorProfile.fromMap(<String, dynamic>{
        'id': 2,
        'name': 'Jane Farmer',
        'email': 'jane@farm.test',
      });

      expect(vendor.displayName, 'Jane Farmer');
      expect(vendor.businessName, isNull);
    });

    test('handles null optional fields', () {
      final vendor = VendorProfile.fromMap(<String, dynamic>{
        'id': 3,
        'name': '',
        'email': '',
      });

      expect(vendor.phoneNumber, isNull);
      expect(vendor.businessName, isNull);
      expect(vendor.shopDescription, isNull);
      expect(vendor.isOpen, isFalse);
      expect(vendor.isVerified, isFalse);
      expect(vendor.productCount, 0);
    });
  });
}
