import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wishlist_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<WishlistService>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('WishlistController', () {
    late MockWishlistService mockService;
    late WishlistController controller;
    final product1 = VendorInventory(
      id: 1,
      price: 10.0,
      stockQuantity: 5.0,
    );
    final product2 = VendorInventory(
      id: 2,
      price: 20.0,
      stockQuantity: 3.0,
    );

    setUp(() {
      mockService = MockWishlistService();
      controller = WishlistController(wishlistService: mockService);
    });

    tearDown(() {
      Get.reset();
    });

    test('isFavorite returns false when list is empty', () {
      expect(controller.isFavorite(1), isFalse);
    });

    test('isFavorite returns true when item exists in list', () {
      controller.items.add(product1);
      expect(controller.isFavorite(1), isTrue);
      expect(controller.isFavorite(2), isFalse);
    });

    test('isFavorite returns false after item is removed', () {
      controller.items.add(product1);
      controller.items.removeWhere((item) => item.id == 1);
      expect(controller.isFavorite(1), isFalse);
    });

    test('fetchPage delegates to wishlistService.getWishlist', () async {
      when(mockService.getWishlist(page: anyNamed('page'))).thenAnswer(
        (_) async => PaginatedResponse<VendorInventory>(
          items: [product1],
          currentPage: 1,
        ),
      );

      final result = await controller.fetchPage(1);

      expect(result.items.length, 1);
      expect(result.items.first.id, 1);
    });

    test('toggleWishlist adds item optimistically on success', () async {
      when(mockService.toggleWishlist(any)).thenAnswer((_) async => true);
      controller.items.add(product2);

      await controller.toggleWishlist(product1);

      expect(controller.items.length, 2);
      expect(controller.isFavorite(1), isTrue);
    });

    test('toggleWishlist removes item optimistically on success', () async {
      when(mockService.toggleWishlist(any)).thenAnswer((_) async => true);
      controller.items.add(product1);
      controller.items.add(product2);

      await controller.toggleWishlist(product1);

      expect(controller.items.length, 1);
      expect(controller.isFavorite(1), isFalse);
    });

    testWidgets('toggleWishlist reverts add on failure', (tester) async {
      when(mockService.toggleWishlist(any)).thenAnswer((_) async => false);

      await tester.pumpWidget(
        const GetMaterialApp(home: Text('')),
      );

      await controller.toggleWishlist(product1);
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));

      expect(controller.items.length, 0);
      expect(controller.isFavorite(1), isFalse);
    });

    testWidgets('toggleWishlist reverts remove on failure', (tester) async {
      when(mockService.toggleWishlist(any)).thenAnswer((_) async => false);
      controller.items.add(product1);

      await tester.pumpWidget(
        const GetMaterialApp(home: Text('')),
      );

      await controller.toggleWishlist(product1);
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));

      expect(controller.items.length, 1);
      expect(controller.isFavorite(1), isTrue);
    });
  });
}
