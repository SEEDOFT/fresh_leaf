import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';

void main() {
  group('MoneyDisplay', () {
    test('parses USD and KHR display maps', () {
      final display = MoneyDisplay.fromMap(<String, dynamic>{
        'USD': '12.50',
        'KHR': '51250.00',
      });

      expect(display.usd, 12.5);
      expect(display.khr, 51250);
      expect(display.usdText, r'$12.50');
      expect(display.khrText, '51,250 KHR');
      expect(display.usdToKhrRateText, '1 USD = 4,100 KHR');
      expect(display.khrToUsdRateText, r'1 KHR = $0.00024390');
    });

    test('multiplies display amounts for product detail previews', () {
      final display = MoneyDisplay.fromMap(<String, dynamic>{
        'USD': '2.50',
        'KHR': '10250.00',
      }).multiply(3);

      expect(display.usdText, r'$7.50');
      expect(display.khrText, '30,750 KHR');
    });
  });

  test('VendorInventory parses product dual currency displays', () {
    final inventory = VendorInventory.fromMap(<String, dynamic>{
      'id': 1,
      'price': '3.00',
      'discount_percentage': '10.00',
      'stock_quantity': '5.00',
      'price_display': <String, dynamic>{
        'USD': '3.00',
        'KHR': '12300.00',
      },
      'discounted_price_display': <String, dynamic>{
        'USD': '2.70',
        'KHR': '11070.00',
      },
    });

    expect(inventory.resolvedPriceDisplay.usdText, r'$3.00');
    expect(inventory.resolvedFinalPriceDisplay.khrText, '11,070 KHR');
  });

  test('CartItem parses line dual currency displays', () {
    final item = CartItem.fromMap(<String, dynamic>{
      'id': 1,
      'vendor_inventory_id': 10,
      'quantity': '2.00',
      'subtotal': '5.40',
      'discounted_unit_price_display': <String, dynamic>{
        'USD': '2.70',
        'KHR': '11070.00',
      },
      'subtotal_display': <String, dynamic>{
        'USD': '5.40',
        'KHR': '22140.00',
      },
    });

    expect(item.resolvedUnitPriceDisplay.usdText, r'$2.70');
    expect(item.resolvedSubtotalDisplay.khrText, '22,140 KHR');
  });

  test('Order parses total and item dual currency displays', () {
    final order = Order.fromMap(<String, dynamic>{
      'id': 1,
      'order_number': 'FL250526000001',
      'total_amount': '5.40',
      'subtotal': '6.00',
      'discount_amount': '0.60',
      'delivery_fee': '0.00',
      'tax_amount': '0.00',
      'total_amount_display': <String, dynamic>{
        'USD': '5.40',
        'KHR': '22140.00',
      },
      'items': <dynamic>[
        <String, dynamic>{
          'id': 1,
          'product_name_snapshot': 'Carrot',
          'quantity': '2.00',
          'subtotal': '5.40',
          'unit_price_snapshot_display': <String, dynamic>{
            'USD': '2.70',
            'KHR': '11070.00',
          },
          'subtotal_display': <String, dynamic>{
            'USD': '5.40',
            'KHR': '22140.00',
          },
        },
      ],
    });

    expect(order.resolvedTotalAmountDisplay.usdText, r'$5.40');
    expect(order.items.single.resolvedUnitPriceDisplay.khrText, '11,070 KHR');
    expect(order.items.single.resolvedSubtotalDisplay.khrText, '22,140 KHR');
  });
}
