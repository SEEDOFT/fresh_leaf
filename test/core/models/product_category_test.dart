import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/product_category.dart';

void main() {
  group('ProductCategory', () {
    test('maps id 1 to leaf icon', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 1,
        'name': 'Leafy Greens',
      });

      expect(category.icon, ProductCategoryIcon.leaf);
      expect(category.name, 'Leafy Greens');
    });

    test('maps id 2 to fruit icon', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 2,
        'name': 'Fruits',
      });

      expect(category.icon, ProductCategoryIcon.fruit);
    });

    test('maps id 3 to rootAndTuber', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 3,
        'name': 'Roots & Tubers',
      });

      expect(category.icon, ProductCategoryIcon.rootAndTuber);
    });

    test('maps id 4 to bulbAndStem', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 4,
        'name': 'Bulbs & Stems',
      });

      expect(category.icon, ProductCategoryIcon.bulbAndStem);
    });

    test('maps id 5 to legume', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 5,
        'name': 'Legumes',
      });

      expect(category.icon, ProductCategoryIcon.legume);
    });

    test('maps id 6 to indigenousAndWild', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 6,
        'name': 'Indigenous & Wild',
      });

      expect(category.icon, ProductCategoryIcon.indigenousAndWild);
    });

    test('defaults unknown id to leaf', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 99,
        'name': 'Unknown',
      });

      expect(category.icon, ProductCategoryIcon.leaf);
    });

    test('parses with all fields', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 2,
        'name': 'Fruits',
        'description': 'Fresh tropical fruits',
        'image_url': 'https://example.test/fruits.png',
        'slug': 'fruits',
      });

      expect(category.description, 'Fresh tropical fruits');
      expect(category.imageUrl, 'https://example.test/fruits.png');
      expect(category.slug, 'fruits');
    });

    test('toMap and copyWith round-trip correctly', () {
      final category = ProductCategory.fromMap(<String, dynamic>{
        'id': 1,
        'name': 'Leafy Greens',
        'slug': 'leafy-greens',
      });

      final map = category.toMap();
      expect(map['id'], 1);
      expect(map['name'], 'Leafy Greens');
      expect(map['icon'], 'leaf');

      final copy = category.copyWith(name: 'Lettuce');
      expect(copy.id, 1);
      expect(copy.name, 'Lettuce');
    });
  });
}
