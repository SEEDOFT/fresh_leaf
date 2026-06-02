import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/product_info.dart';

void main() {
  group('ProductInfo', () {
    test('parses from snake_case map', () {
      final info = ProductInfo.fromMap(<String, dynamic>{
        'id': 1,
        'title': 'Fresh Carrot',
        'subtitle': 'Organic',
        'description': 'Locally grown carrots',
        'imageUrl': 'https://example.test/carrot.png',
        'tags': <dynamic>['organic', 'fresh'],
        'price': '2.50',
        'origin': 'Cambodia',
        'harvest': '2026-05-01',
        'storage': 'Cool dry place',
        'share_slug': 'fresh-carrot',
        'share_deep_link': 'freshleaf://product/1',
        'original_price': '3.00',
        'price_khr': '10250.00',
      });

      expect(info.id, 1);
      expect(info.title, 'Fresh Carrot');
      expect(info.subtitle, 'Organic');
      expect(info.price, 2.5);
      expect(info.tags, ['organic', 'fresh']);
      expect(info.shareSlug, 'fresh-carrot');
      expect(info.shareDeepLink, 'freshleaf://product/1');
      expect(info.originalPrice, 3.0);
      expect(info.priceKhr, 10250.0);
    });

    test('falls back to camelCase keys when snake_case absent', () {
      final info = ProductInfo.fromMap(<String, dynamic>{
        'id': 2,
        'title': 'Apple',
        'subtitle': '',
        'description': 'Sweet',
        'imageUrl': '',
        'tags': <dynamic>[],
        'price': 1.5,
        'origin': '',
        'harvest': '',
        'storage': '',
        'shareSlug': 'apple',
        'shareDeepLink': 'freshleaf://product/2',
        'originalPrice': 2.0,
        'priceKhr': 6150.0,
      });

      expect(info.shareSlug, 'apple');
      expect(info.shareDeepLink, 'freshleaf://product/2');
      expect(info.originalPrice, 2.0);
      expect(info.priceKhr, 6150.0);
    });

    test('handles missing optional fields', () {
      final info = ProductInfo.fromMap(<String, dynamic>{
        'id': 0,
        'title': '',
        'subtitle': '',
        'description': '',
        'imageUrl': '',
        'tags': null,
        'price': null,
        'origin': '',
        'harvest': '',
        'storage': '',
      });

      expect(info.id, 0);
      expect(info.tags, isEmpty);
      expect(info.price, 0.0);
      expect(info.shareSlug, '');
    });

    test('toMap round-trip', () {
      final info = ProductInfo.fromMap(<String, dynamic>{
        'id': 1,
        'title': 'Banana',
        'subtitle': '',
        'description': 'Yellow fruit',
        'imageUrl': '',
        'tags': <dynamic>['fruit'],
        'price': '1.00',
        'origin': '',
        'harvest': '',
        'storage': '',
      });

      final map = info.toMap();
      expect(map['title'], 'Banana');
      expect(map['price'], 1.0);
      expect(map['tags'], ['fruit']);
    });

    test('copyWith overrides specified fields', () {
      final info = ProductInfo.fromMap(<String, dynamic>{
        'id': 1,
        'title': 'Carrot',
        'subtitle': '',
        'description': '',
        'imageUrl': '',
        'tags': <dynamic>[],
        'price': 0,
        'origin': '',
        'harvest': '',
        'storage': '',
      });

      final copy = info.copyWith(title: 'Organic Carrot', price: 3.5);
      expect(copy.title, 'Organic Carrot');
      expect(copy.price, 3.5);
      expect(copy.id, 1);
    });
  });
}
