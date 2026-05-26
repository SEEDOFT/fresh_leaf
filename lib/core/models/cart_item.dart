import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class CartItem {
  CartItem({
    required this.id,
    required this.vendorInventoryId,
    required this.quantity,
    required this.subtotal,
    this.vendorInventory,
    this.unitPriceDisplay = MoneyDisplay.empty,
    this.discountedUnitPriceDisplay = MoneyDisplay.empty,
    this.subtotalDisplay = MoneyDisplay.empty,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int,
      vendorInventoryId: map['vendor_inventory_id'] as int,
      quantity: toDouble(map['quantity']),
      subtotal: toDouble(map['subtotal']),
      unitPriceDisplay: MoneyDisplay.fromMap(map['unit_price_display']),
      discountedUnitPriceDisplay: MoneyDisplay.fromMap(
        map['discounted_unit_price_display'],
      ),
      subtotalDisplay: MoneyDisplay.fromMap(map['subtotal_display']),
      vendorInventory: map['vendor_inventory'] != null
          ? VendorInventory.fromMap(
              map['vendor_inventory'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final int id;
  final int vendorInventoryId;
  final double quantity;
  final double subtotal;
  final VendorInventory? vendorInventory;
  final MoneyDisplay unitPriceDisplay;
  final MoneyDisplay discountedUnitPriceDisplay;
  final MoneyDisplay subtotalDisplay;

  MoneyDisplay get resolvedUnitPriceDisplay {
    if (!discountedUnitPriceDisplay.isEmpty) {
      return discountedUnitPriceDisplay;
    }
    if (!unitPriceDisplay.isEmpty) return unitPriceDisplay;
    return vendorInventory?.resolvedFinalPriceDisplay ?? MoneyDisplay.empty;
  }

  MoneyDisplay get resolvedSubtotalDisplay {
    if (!subtotalDisplay.isEmpty) return subtotalDisplay;
    final unitDisplay = resolvedUnitPriceDisplay;
    if (!unitDisplay.isEmpty) return unitDisplay.multiply(quantity);
    return MoneyDisplay.fromCurrencyAmount(
      amount: subtotal,
      currencyId: vendorInventory?.currencyId,
    );
  }
}
