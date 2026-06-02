import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/models/money_display.dart';

void main() {
  group('Order', () {
    test('fromMap parses full map correctly', () {
      final order = Order.fromMap(<String, dynamic>{
        'id': 1,
        'order_number': 'FL-001',
        'total_amount': '100.00',
        'subtotal': '80.00',
        'discount_amount': '10.00',
        'delivery_fee': '5.00',
        'tax_amount': '5.00',
        'status': <String, dynamic>{'id': 2},
        'payment_status': <String, dynamic>{'id': 1},
        'type': <String, dynamic>{'id': 1},
        'delivery_date': '2026-06-15',
        'delivery_slot': 'Morning',
        'notes': 'Leave at door',
        'created_at': '2026-06-14T10:00:00.000',
        'preparation_proof_photo': 'https://example.test/proof.jpg',
        'delivery_company_name': 'QuickShip',
        'delivery_tracking_info': 'TRACK-123',
        'total_amount_display': <String, dynamic>{
          'USD': '100.00',
          'KHR': '410000.00',
        },
        'subtotal_display': <String, dynamic>{'USD': '80.00', 'KHR': '328000.00'},
        'discount_amount_display': <String, dynamic>{
          'USD': '10.00',
          'KHR': '41000.00',
        },
        'delivery_fee_display': <String, dynamic>{
          'USD': '5.00',
          'KHR': '20500.00',
        },
        'tax_amount_display': <String, dynamic>{'USD': '5.00', 'KHR': '20500.00'},
        'items': <dynamic>[
          <String, dynamic>{
            'id': 1,
            'product_name_snapshot': 'Carrot',
            'quantity': '2',
            'subtotal': '10.00',
            'unit_price_snapshot_display': <String, dynamic>{
              'USD': '5.00',
              'KHR': '20500.00',
            },
            'subtotal_display': <String, dynamic>{
              'USD': '10.00',
              'KHR': '41000.00',
            },
          },
        ],
      });

      expect(order.id, 1);
      expect(order.orderNumber, 'FL-001');
      expect(order.totalAmount, 100.0);
      expect(order.subtotal, 80.0);
      expect(order.discountAmount, 10.0);
      expect(order.deliveryFee, 5.0);
      expect(order.taxAmount, 5.0);
      expect(order.statusId, 2);
      expect(order.paymentStatusId, 1);
      expect(order.orderTypeId, 1);
      expect(order.deliveryDate, isNotNull);
      expect(order.deliverySlot, 'Morning');
      expect(order.notes, 'Leave at door');
      expect(order.createdAt, isNotNull);
      expect(order.preparationProofPhoto, 'https://example.test/proof.jpg');
      expect(order.deliveryCompanyName, 'QuickShip');
      expect(order.deliveryTrackingInfo, 'TRACK-123');
      expect(order.totalAmountDisplay.usd, 100.0);
      expect(order.items.length, 1);
      expect(order.items.first.id, 1);
    });

    test('fromMap handles missing optional fields', () {
      final order = Order.fromMap(<String, dynamic>{
        'id': 2,
        'order_number': 'FL-002',
        'total_amount': '50.00',
        'subtotal': '50.00',
      });

      expect(order.id, 2);
      expect(order.discountAmount, 0.0);
      expect(order.deliveryFee, 0.0);
      expect(order.taxAmount, 0.0);
      expect(order.statusId, isNull);
      expect(order.paymentStatusId, isNull);
      expect(order.orderTypeId, isNull);
      expect(order.deliveryDate, isNull);
      expect(order.deliverySlot, isNull);
      expect(order.notes, isNull);
      expect(order.createdAt, isNull);
      expect(order.preparationProofPhoto, isNull);
      expect(order.deliveryCompanyName, isNull);
      expect(order.deliveryTrackingInfo, isNull);
      expect(order.totalAmountDisplay.isEmpty, isTrue);
      expect(order.items, isEmpty);
    });

    test('status returns correct label based on statusId', () {
      final base = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0);
      final pending = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, statusId: 1);
      final confirmed = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, statusId: 2);
      final preparing = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, statusId: 3);
      final delivered = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, statusId: 4);
      final cancelled = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, statusId: 5);
      final awaitingPayment = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, statusId: 6);

      expect(base.status, 'order_pending');
      expect(pending.status, 'order_pending');
      expect(confirmed.status, 'order_confirmed');
      expect(preparing.status, 'order_preparing');
      expect(delivered.status, 'order_delivered');
      expect(cancelled.status, 'order_cancelled');
      expect(awaitingPayment.status, 'order_awaiting_payment');
    });

    test('paymentStatus returns correct label based on paymentStatusId', () {
      final pending = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, paymentStatusId: 1);
      final completed = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, paymentStatusId: 2);
      final failed = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, paymentStatusId: 3);
      final refunded = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, paymentStatusId: 4);

      expect(pending.paymentStatus, 'payment_pending');
      expect(completed.paymentStatus, 'payment_completed');
      expect(failed.paymentStatus, 'payment_failed');
      expect(refunded.paymentStatus, 'payment_refunded');
    });

    test('paymentStatus defaults to pending for unknown id', () {
      final order = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, paymentStatusId: 99);
      expect(order.paymentStatus, 'payment_pending');
    });

    test('orderType returns label based on orderTypeId', () {
      final standard = Order(id: 1, orderNumber: 'FL-001', totalAmount: 10.0, subtotal: 10.0, orderTypeId: 1);
      expect(standard.orderType, 'order_standard');
    });

    test('resolved display getters use existing display when not empty', () {
      final order = Order(
        id: 1,
        orderNumber: 'FL-001',
        totalAmount: 100.0,
        subtotal: 80.0,
        discountAmount: 10.0,
        deliveryFee: 5.0,
        taxAmount: 5.0,
        totalAmountDisplay: MoneyDisplay(usd: 100.0, khr: 410000.0),
        subtotalDisplay: MoneyDisplay(usd: 80.0, khr: 328000.0),
        discountAmountDisplay: MoneyDisplay(usd: 10.0, khr: 41000.0),
        deliveryFeeDisplay: MoneyDisplay(usd: 5.0, khr: 20500.0),
        taxAmountDisplay: MoneyDisplay(usd: 5.0, khr: 20500.0),
      );

      expect(order.resolvedTotalAmountDisplay.usd, 100.0);
      expect(order.resolvedSubtotalDisplay.usd, 80.0);
      expect(order.resolvedDiscountAmountDisplay.usd, 10.0);
      expect(order.resolvedDeliveryFeeDisplay.usd, 5.0);
      expect(order.resolvedTaxAmountDisplay.usd, 5.0);
    });

    test('resolved display getters fall back to computed values when empty', () {
      final order = Order(
        id: 1,
        orderNumber: 'FL-001',
        totalAmount: 200.0,
        subtotal: 180.0,
        discountAmount: 20.0,
        deliveryFee: 0.0,
        taxAmount: 10.0,
      );

      expect(order.resolvedTotalAmountDisplay.usd, 200.0);
      expect(order.resolvedSubtotalDisplay.usd, 180.0);
      expect(order.resolvedDiscountAmountDisplay.usd, 20.0);
      expect(order.resolvedDeliveryFeeDisplay.usd, 0.0);
      expect(order.resolvedTaxAmountDisplay.usd, 10.0);
    });
  });

  group('OrderItem', () {
    test('fromMap parses full map correctly', () {
      final item = OrderItem.fromMap(<String, dynamic>{
        'id': 1,
        'product_name_snapshot': 'Carrot',
        'quantity': '2',
        'subtotal': '10.00',
        'unit_price_snapshot_display': <String, dynamic>{
          'USD': '5.00',
          'KHR': '20500.00',
        },
        'subtotal_display': <String, dynamic>{
          'USD': '10.00',
          'KHR': '41000.00',
        },
      });

      expect(item.id, 1);
      expect(item.productNameSnapshot, 'Carrot');
      expect(item.quantity, 2.0);
      expect(item.subtotal, 10.0);
      expect(item.unitPriceSnapshotDisplay.usd, 5.0);
      expect(item.subtotalDisplay.usd, 10.0);
    });

    test('fromMap handles missing optional displays', () {
      final item = OrderItem.fromMap(<String, dynamic>{
        'id': 2,
        'product_name_snapshot': 'Lettuce',
        'quantity': '3',
        'subtotal': '15.00',
      });

      expect(item.id, 2);
      expect(item.productNameSnapshot, 'Lettuce');
      expect(item.quantity, 3.0);
      expect(item.subtotal, 15.0);
      expect(item.unitPriceSnapshotDisplay.isEmpty, isTrue);
      expect(item.subtotalDisplay.isEmpty, isTrue);
    });

    test('resolvedUnitPriceDisplay uses snapshot display when available', () {
      final item = OrderItem(
        id: 3,
        productNameSnapshot: 'Tomato',
        quantity: 4.0,
        subtotal: 20.0,
        unitPriceSnapshotDisplay: MoneyDisplay(usd: 5.0, khr: 20500.0),
      );

      expect(item.resolvedUnitPriceDisplay.usd, 5.0);
    });

    test('resolvedUnitPriceDisplay computes from subtotal/quantity', () {
      final item = OrderItem(
        id: 4,
        productNameSnapshot: 'Potato',
        quantity: 5.0,
        subtotal: 25.0,
      );

      expect(item.resolvedUnitPriceDisplay.usd, 5.0);
    });

    test('resolvedUnitPriceDisplay returns empty when quantity is 0', () {
      final item = OrderItem(
        id: 5,
        productNameSnapshot: 'Onion',
        quantity: 0.0,
        subtotal: 10.0,
      );

      expect(item.resolvedUnitPriceDisplay.isEmpty, isTrue);
    });

    test('resolvedSubtotalDisplay uses subtotalDisplay when available', () {
      final item = OrderItem(
        id: 6,
        productNameSnapshot: 'Garlic',
        quantity: 2.0,
        subtotal: 6.0,
        subtotalDisplay: MoneyDisplay(usd: 6.0, khr: 24600.0),
      );

      expect(item.resolvedSubtotalDisplay.usd, 6.0);
    });

    test('resolvedSubtotalDisplay falls back to computed value', () {
      final item = OrderItem(
        id: 7,
        productNameSnapshot: 'Ginger',
        quantity: 1.0,
        subtotal: 3.50,
      );

      expect(item.resolvedSubtotalDisplay.usd, 3.5);
    });
  });
}
