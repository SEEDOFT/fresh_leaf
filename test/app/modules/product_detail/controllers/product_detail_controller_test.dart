import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:fresh_leaf/core/services/rating_service.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:mockito/mockito.dart';

class FakeCartService extends Fake implements CartService {}

class FakeProductService extends Fake implements ProductService {}

class FakeRatingService extends Fake implements RatingService {}

class FakeWishlistService extends Fake implements WishlistService {}

void main() {
  group('ProductDetailController', () {
    late ProductDetailController controller;

    setUp(() {
      controller = ProductDetailController(
        wishlistController: WishlistController(
          wishlistService: FakeWishlistService(),
        ),
        productService: FakeProductService(),
        cartController: CartController(cartService: FakeCartService()),
        ratingService: FakeRatingService(),
      );
    });

    test('allImages lists batch images before product image', () {
      controller.product = VendorInventory.fromMap(<String, dynamic>{
        'id': 1,
        'price': '10.00',
        'stock_quantity': '1.00',
        'batch_images': <dynamic>[
          'https://example.test/batch-1.png',
          'https://example.test/batch-2.png',
        ],
        'product': <String, dynamic>{
          'id': 1,
          'name': 'Carrot',
          'slug': 'carrot',
          'description': 'Fresh carrot',
          'image_url': 'https://example.test/product.png',
        },
        'price_display': <String, dynamic>{},
        'discounted_price_display': <String, dynamic>{},
      });

      expect(controller.allImages, <String>[
        'https://example.test/batch-1.png',
        'https://example.test/batch-2.png',
        'https://example.test/product.png',
      ]);
    });

    test('allImages removes blank and duplicate urls', () {
      controller.product = VendorInventory.fromMap(<String, dynamic>{
        'id': 2,
        'price': '10.00',
        'stock_quantity': '1.00',
        'batch_images': <dynamic>['', 'https://example.test/product.png'],
        'product': <String, dynamic>{
          'id': 2,
          'name': 'Lettuce',
          'slug': 'lettuce',
          'description': 'Green lettuce',
          'image_url': 'https://example.test/product.png',
        },
        'price_display': <String, dynamic>{},
        'discounted_price_display': <String, dynamic>{},
      });

      expect(controller.allImages, <String>[
        'https://example.test/product.png',
      ]);
    });
  });
}
