import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/app_notification.dart';

void main() {
  group('AppNotification', () {
    test('parses notification with all fields', () {
      final notification = AppNotification.fromMap(<String, dynamic>{
        'id': 1,
        'title': 'Order Shipped',
        'message': 'Your order has been shipped.',
        'is_read': true,
        'read_at': '2026-06-01T12:00:00Z',
        'created_at': '2026-06-01T10:00:00Z',
        'type': <String, dynamic>{
          'code': 'order_shipped',
          'name_en': 'Order Shipped',
          'name_km': 'បានដឹកជញ្ជូន',
        },
        'data': <String, dynamic>{'order_id': 123},
      });

      expect(notification.id, 1);
      expect(notification.title, 'Order Shipped');
      expect(notification.message, 'Your order has been shipped.');
      expect(notification.isRead, isTrue);
      expect(notification.readAt, isNotNull);
      expect(notification.createdAt, isNotNull);
      expect(notification.typeCode, 'order_shipped');
      expect(notification.typeNameEn, 'Order Shipped');
      expect(notification.typeNameKm, 'បានដឹកជញ្ជូន');
      expect(notification.data, {'order_id': 123});
    });

    test('parses notification with unread status', () {
      final notification = AppNotification.fromMap(<String, dynamic>{
        'id': 2,
        'title': 'New Offer',
        'message': '50% off on all items',
        'is_read': false,
      });

      expect(notification.isRead, isFalse);
      expect(notification.readAt, isNull);
      expect(notification.typeCode, isNull);
    });

    test('handles missing type map', () {
      final notification = AppNotification.fromMap(<String, dynamic>{
        'id': 3,
        'title': 'Promo',
        'message': 'Check it out',
        'is_read': false,
      });

      expect(notification.typeCode, isNull);
      expect(notification.typeNameEn, isNull);
    });

    test('handles null boolean is_read', () {
      final notification = AppNotification.fromMap(<String, dynamic>{
        'id': 4,
        'title': 'Alert',
        'message': 'Something happened',
        'is_read': null,
      });

      expect(notification.isRead, isFalse);
    });
  });
}
