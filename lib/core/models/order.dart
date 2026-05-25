import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';

class Order {
  Order({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.subtotal,
    this.discountAmount,
    this.deliveryFee,
    this.taxAmount,
    this.statusName,
    this.paymentStatusName,
    this.orderTypeName,
    this.deliveryDate,
    this.deliverySlot,
    this.notes,
    this.createdAt,
    this.items = const [],
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      orderNumber: map['order_number'] as String,
      totalAmount: toDouble(map['total_amount']),
      subtotal: toDouble(map['subtotal']),
      discountAmount: toDouble(map['discount_amount']),
      deliveryFee: toDouble(map['delivery_fee']),
      taxAmount: toDouble(map['tax_amount']),
      statusName:
          (map['status'] as Map<String, dynamic>?)?['translated_name']
              as String?,
      paymentStatusName:
          (map['payment_status'] as Map<String, dynamic>?)?['translated_name']
              as String?,
      orderTypeName:
          (map['type'] as Map<String, dynamic>?)?['translated_name'] as String?,
      deliveryDate: map['delivery_date'] != null
          ? DateTime.tryParse(map['delivery_date'].toString())
          : null,
      deliverySlot: map['delivery_slot'] as String?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      items:
          (map['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final int id;
  final String orderNumber;
  final double totalAmount;
  final double subtotal;
  final double? discountAmount;
  final double? deliveryFee;
  final double? taxAmount;
  final String? statusName;
  final String? paymentStatusName;
  final String? orderTypeName;
  final DateTime? deliveryDate;
  final String? deliverySlot;
  final String? notes;
  final DateTime? createdAt;
  final List<OrderItem> items;
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.productNameSnapshot,
    required this.quantity,
    required this.subtotal,
    this.vendorInventory,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as int,
      productNameSnapshot: formatToString(map['product_name_snapshot']),
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
  final String productNameSnapshot;
  final double quantity;
  final double subtotal;
  final VendorInventory? vendorInventory;
}
