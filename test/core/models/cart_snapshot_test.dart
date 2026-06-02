import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/core/models/cart_snapshot.dart';
import 'package:fresh_leaf/core/models/money_display.dart';

void main() {
  group('CartSnapshot', () {
    test('empty const has empty items and empty display', () {
      expect(CartSnapshot.empty.items, isEmpty);
      expect(CartSnapshot.empty.totalDisplay.isEmpty, isTrue);
    });

    test('constructor sets items and totalDisplay', () {
      final item = CartItem(
        id: 1,
        vendorInventoryId: 10,
        quantity: 2.0,
        subtotal: 20.0,
      );
      final display = MoneyDisplay(usd: 20.0, khr: 82000.0);
      final snapshot = CartSnapshot(items: [item], totalDisplay: display);

      expect(snapshot.items.length, 1);
      expect(snapshot.items.first.id, 1);
      expect(snapshot.totalDisplay.usd, 20.0);
      expect(snapshot.totalDisplay.khr, 82000.0);
    });

    test('items list is mutable', () {
      final item = CartItem(
        id: 2,
        vendorInventoryId: 20,
        quantity: 1.0,
        subtotal: 5.0,
      );
      final snapshot = CartSnapshot(
        items: [item],
        totalDisplay: MoneyDisplay(usd: 5.0, khr: 20500.0),
      );

      expect(snapshot.items, hasLength(1));
      snapshot.items.add(
        CartItem(
          id: 3,
          vendorInventoryId: 30,
          quantity: 3.0,
          subtotal: 15.0,
        ),
      );
      expect(snapshot.items, hasLength(2));
    });
  });
}
