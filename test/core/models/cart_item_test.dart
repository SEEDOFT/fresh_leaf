import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';

void main() {
  group('CartItem', () {
    test('fromMap parses full map correctly', () {
      final item = CartItem.fromMap(<String, dynamic>{
        'id': 1,
        'vendor_inventory_id': 10,
        'quantity': '2.50',
        'subtotal': '25.00',
        'unit_price_display': <String, dynamic>{
          'USD': '12.50',
          'KHR': '51250.00',
        },
        'discounted_unit_price_display': <String, dynamic>{},
        'subtotal_display': <String, dynamic>{
          'USD': '25.00',
          'KHR': '102500.00',
        },
        'vendor_inventory': <String, dynamic>{
          'id': 10,
          'price': '12.50',
          'stock_quantity': '5.00',
          'price_display': <String, dynamic>{
            'USD': '12.50',
            'KHR': '51250.00',
          },
          'discounted_price_display': <String, dynamic>{},
        },
      });

      expect(item.id, 1);
      expect(item.vendorInventoryId, 10);
      expect(item.quantity, 2.5);
      expect(item.subtotal, 25.0);
      expect(item.unitPriceDisplay.usd, 12.5);
      expect(item.discountedUnitPriceDisplay.isEmpty, isTrue);
      expect(item.subtotalDisplay.usd, 25.0);
      expect(item.vendorInventory, isNotNull);
      expect(item.vendorInventory!.id, 10);
    });

    test('fromMap handles missing optional fields', () {
      final item = CartItem.fromMap(<String, dynamic>{
        'id': 2,
        'vendor_inventory_id': 20,
        'quantity': '1',
        'subtotal': '10.00',
      });

      expect(item.id, 2);
      expect(item.quantity, 1.0);
      expect(item.subtotal, 10.0);
      expect(item.unitPriceDisplay.isEmpty, isTrue);
      expect(item.discountedUnitPriceDisplay.isEmpty, isTrue);
      expect(item.subtotalDisplay.isEmpty, isTrue);
      expect(item.vendorInventory, isNull);
    });

    test('resolvedUnitPriceDisplay uses discounted when available', () {
      final item = CartItem(
        id: 3,
        vendorInventoryId: 30,
        quantity: 1.0,
        subtotal: 8.0,
        unitPriceDisplay: MoneyDisplay(usd: 10.0, khr: 41000.0),
        discountedUnitPriceDisplay: MoneyDisplay(usd: 8.0, khr: 32800.0),
      );

      expect(item.resolvedUnitPriceDisplay.usd, 8.0);
    });

    test('resolvedUnitPriceDisplay falls back to unitPriceDisplay', () {
      final item = CartItem(
        id: 4,
        vendorInventoryId: 40,
        quantity: 1.0,
        subtotal: 10.0,
        unitPriceDisplay: MoneyDisplay(usd: 10.0, khr: 41000.0),
      );

      expect(item.resolvedUnitPriceDisplay.usd, 10.0);
    });

    test('resolvedUnitPriceDisplay falls back to vendorInventory display', () {
      final item = CartItem(
        id: 5,
        vendorInventoryId: 50,
        quantity: 1.0,
        subtotal: 15.0,
        vendorInventory: VendorInventory(
          id: 50,
          price: 15.0,
          stockQuantity: 10.0,
          priceDisplay: MoneyDisplay(usd: 15.0, khr: 61500.0),
        ),
      );

      expect(item.resolvedUnitPriceDisplay.usd, 15.0);
    });

    test('resolvedUnitPriceDisplay returns empty when nothing available', () {
      final item = CartItem(
        id: 6,
        vendorInventoryId: 60,
        quantity: 1.0,
        subtotal: 5.0,
      );

      expect(item.resolvedUnitPriceDisplay.isEmpty, isTrue);
    });

    test('resolvedSubtotalDisplay uses subtotalDisplay when available', () {
      final item = CartItem(
        id: 7,
        vendorInventoryId: 70,
        quantity: 2.0,
        subtotal: 20.0,
        subtotalDisplay: MoneyDisplay(usd: 20.0, khr: 82000.0),
      );

      expect(item.resolvedSubtotalDisplay.usd, 20.0);
    });

    test(
      'resolvedSubtotalDisplay computes from unit display when no subtotal display',
      () {
        final item = CartItem(
          id: 8,
          vendorInventoryId: 80,
          quantity: 3.0,
          subtotal: 30.0,
          unitPriceDisplay: MoneyDisplay(usd: 10.0, khr: 41000.0),
        );

        expect(item.resolvedSubtotalDisplay.usd, 30.0);
        expect(item.resolvedSubtotalDisplay.khr, 123000.0);
      },
    );

    test('resolvedSubtotalDisplay falls back to fromCurrencyAmount', () {
      final item = CartItem(
        id: 9,
        vendorInventoryId: 90,
        quantity: 4.0,
        subtotal: 40.0,
      );

      expect(item.resolvedSubtotalDisplay.usd, 40.0);
      expect(item.resolvedSubtotalDisplay.khr, 0.0);
    });
  });
}
