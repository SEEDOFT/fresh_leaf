import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/product.dart';

void main() {
  group('Product', () {
    test('parses minimal product map', () {
      final product = Product.fromMap(<String, dynamic>{
        'id': 1,
        'name': 'Fresh Carrot',
        'slug': 'fresh-carrot',
        'description': 'Organic carrot from local farm',
      });

      expect(product.id, 1);
      expect(product.name, 'Fresh Carrot');
      expect(product.slug, 'fresh-carrot');
      expect(product.description, 'Organic carrot from local farm');
      expect(product.imageUrl, '');
      expect(product.productCategoryId, isNull);
    });

    test('parses product with nested category, type, and status', () {
      final product = Product.fromMap(<String, dynamic>{
        'id': 2,
        'name': 'Organic Apple',
        'slug': 'organic-apple',
        'description': 'Sweet apples',
        'image_url': 'https://example.test/apple.png',
        'nutrition_data': <String, dynamic>{'calories': 52},
        'product_category': <String, dynamic>{
          'id': 1,
          'name': 'Fruits',
        },
        'type': <String, dynamic>{
          'id': 3,
          'name': 'Organic',
        },
        'status': <String, dynamic>{
          'id': 1,
          'name': 'Active',
        },
      });

      expect(product.imageUrl, 'https://example.test/apple.png');
      expect(product.nutritionData, {'calories': 52});
      expect(product.productCategoryId, 1);
      expect(product.productCategoryName, 'Fruits');
      expect(product.typeId, 3);
      expect(product.typeName, 'Organic');
      expect(product.statusId, 1);
      expect(product.statusName, 'Active');
    });

    test('handles missing nested maps', () {
      final product = Product.fromMap(<String, dynamic>{
        'id': 3,
        'name': 'Bare Product',
        'slug': 'bare-product',
        'description': 'No nested data',
      });

      expect(product.productCategoryId, isNull);
      expect(product.productCategoryName, isNull);
      expect(product.typeId, isNull);
      expect(product.statusId, isNull);
    });

    test(
      'localizedName and localizedDescription return name and description',
      () {
        final product = Product.fromMap(<String, dynamic>{
          'id': 1,
          'name': 'Banana',
          'slug': 'banana',
          'description': 'Yellow fruit',
        });

        expect(product.localizedName, 'Banana');
        expect(product.localizedDescription, 'Yellow fruit');
      },
    );
  });
}
