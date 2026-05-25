import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class CartItem {
  CartItem({
    required this.id,
    required this.vendorInventoryId,
    required this.quantity,
    required this.subtotal,
    this.vendorInventory,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int,
      vendorInventoryId: map['vendor_inventory_id'] as int,
      quantity: toDouble(map['quantity']),
      subtotal: toDouble(map['subtotal']),
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
}
