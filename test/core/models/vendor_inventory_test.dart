import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';

void main() {
  group('VendorInventory', () {
    test('parses full map with nested objects', () {
      final inventory = VendorInventory.fromMap(<String, dynamic>{
        'id': 1,
        'price': '10.00',
        'stock_quantity': '50.00',
        'harvest_date': '2026-06-01',
        'harvest_date_human': 'June 1, 2026',
        'farm_location': 'Farm A',
        'province_of_origin': 'Battambang',
        'certification_type': 'Organic',
        'packaging_type': <String, dynamic>{'id': 1, 'name': 'Box'},
        'shelf_life_days': 7,
        'batch_images': <dynamic>[
          'https://example.test/img1.png',
          'https://example.test/img2.png',
        ],
        'unit': <String, dynamic>{'id': 1, 'name': 'Kilogram', 'symbol': 'kg'},
        'vendor': <String, dynamic>{
          'id': 1,
          'name': 'Green Farm',
          'phone': '012345',
          'email': 'farm@test.com',
          'address': '123 Farm Rd',
          'business_name': 'Green Basket',
          'shop_description': 'Fresh produce',
          'store_front_image': 'https://example.test/store.png',
          'province': 'Battambang',
          'opening_time': '06:00',
          'closing_time': '18:00',
          'is_open': true,
          'is_verified': true,
          'product_count': 30,
        },
        'discount_percentage': '10.00',
        'price_display': <String, dynamic>{
          'USD': '10.00',
          'KHR': '41000.00',
        },
        'discounted_price_display': <String, dynamic>{
          'USD': '9.00',
          'KHR': '36900.00',
        },
      });

      expect(inventory.id, 1);
      expect(inventory.price, 10.0);
      expect(inventory.stockQuantity, 50.0);
      expect(inventory.harvestDate, isNotNull);
      expect(inventory.harvestDateHuman, 'June 1, 2026');
      expect(inventory.packagingTypeId, 1);
      expect(inventory.packagingTypeName, 'Box');
      expect(inventory.shelfLifeDays, 7);
      expect(inventory.batchImages?.length, 2);
      expect(inventory.unitName, 'Kilogram');
      expect(inventory.unitSymbol, 'kg');
      expect(inventory.vendorName, 'Green Farm');
      expect(inventory.vendorIsOpen, isTrue);
      expect(inventory.vendorIsVerified, isTrue);
      expect(inventory.vendorProductCount, 30);
      expect(inventory.discountPercentage, 10.0);
      expect(inventory.priceDisplay.usdText, r'$10.00');
      expect(inventory.discountedPriceDisplay.usdText, r'$9.00');
    });

    test('handles missing optional fields', () {
      final inventory = VendorInventory.fromMap(<String, dynamic>{
        'id': 2,
        'price': '5.00',
        'stock_quantity': '10.00',
        'price_display': <String, dynamic>{'USD': '5.00', 'KHR': '20500.00'},
        'discounted_price_display': <String, dynamic>{},
      });

      expect(inventory.product, isNull);
      expect(inventory.vendorName, isNull);
      expect(inventory.vendorIsOpen, isFalse);
      expect(inventory.vendorIsVerified, isFalse);
      expect(inventory.vendorProductCount, 0);
      expect(inventory.batchImages, isNull);
      expect(inventory.discountedPriceDisplay.isEmpty, isTrue);
    });

    test('finalPrice applies discount', () {
      final inventory = VendorInventory.fromMap(<String, dynamic>{
        'id': 3,
        'price': '100.00',
        'stock_quantity': '1.00',
        'discount_percentage': '20.00',
        'price_display': <String, dynamic>{'USD': '100.00', 'KHR': '410000.00'},
        'discounted_price_display': <String, dynamic>{},
      });

      expect(inventory.finalPrice, 80.0);
    });

    test('finalPrice clamps discount to 0-100 range', () {
      final overDiscount = VendorInventory.fromMap(<String, dynamic>{
        'id': 4,
        'price': '50.00',
        'stock_quantity': '1.00',
        'discount_percentage': '200.00',
        'price_display': <String, dynamic>{'USD': '50.00', 'KHR': '205000.00'},
        'discounted_price_display': <String, dynamic>{},
      });

      expect(overDiscount.finalPrice, 0.0);

      final noDiscount = VendorInventory.fromMap(<String, dynamic>{
        'id': 5,
        'price': '50.00',
        'stock_quantity': '1.00',
        'price_display': <String, dynamic>{'USD': '50.00', 'KHR': '205000.00'},
        'discounted_price_display': <String, dynamic>{},
      });

      expect(noDiscount.finalPrice, 50.0);
    });

    test('resolvedPriceDisplay uses priceDisplay when available', () {
      final inventory = VendorInventory.fromMap(<String, dynamic>{
        'id': 6,
        'price': '10.00',
        'stock_quantity': '1.00',
        'price_display': <String, dynamic>{
          'USD': '10.00',
          'KHR': '41000.00',
        },
        'discounted_price_display': <String, dynamic>{},
      });

      expect(inventory.resolvedPriceDisplay.usd, 10.0);
    });

    test('display helpers return correct values', () {
      final inventory = VendorInventory.fromMap(<String, dynamic>{
        'id': 7,
        'price': '10.00',
        'stock_quantity': '1.00',
        'packaging_type': <String, dynamic>{'id': 1, 'name': 'Bag'},
        'batch_images': <dynamic>['https://example.test/img.png'],
        'product': <String, dynamic>{
          'id': 1,
          'name': 'Carrot',
          'slug': 'carrot',
          'description': 'Fresh carrot',
          'image_url': 'https://example.test/product.png',
        },
        'price_display': <String, dynamic>{'USD': '10.00', 'KHR': '41000.00'},
        'discounted_price_display': <String, dynamic>{},
      });

      expect(inventory.displayTitle, 'Carrot');
      expect(inventory.displaySubtitle, 'Bag');
      expect(inventory.displayDescription, 'Fresh carrot');
      expect(inventory.displayImageUrl, 'https://example.test/img.png');
    });

    test(
      'displayImageUrl falls back to product image when no batch images',
      () {
        final inventory = VendorInventory.fromMap(<String, dynamic>{
          'id': 8,
          'price': '5.00',
          'stock_quantity': '1.00',
          'product': <String, dynamic>{
            'id': 2,
            'name': 'Lettuce',
            'slug': 'lettuce',
            'description': 'Green lettuce',
            'image_url': 'https://example.test/lettuce.png',
          },
          'price_display': <String, dynamic>{'USD': '5.00', 'KHR': '20500.00'},
          'discounted_price_display': <String, dynamic>{},
        });

        expect(inventory.displayImageUrl, 'https://example.test/lettuce.png');
      },
    );

    test(
      'displayImageUrl falls back to empty string when nothing available',
      () {
        final inventory = VendorInventory.fromMap(<String, dynamic>{
          'id': 9,
          'price': '3.00',
          'stock_quantity': '1.00',
          'price_display': <String, dynamic>{'USD': '3.00', 'KHR': '12300.00'},
          'discounted_price_display': <String, dynamic>{},
        });

        expect(inventory.displayImageUrl, '');
      },
    );
  });
}
