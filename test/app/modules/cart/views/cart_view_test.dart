import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_view.dart';
import 'package:fresh_leaf/app/modules/cart/widgets/cart_empty_widget.dart';
import 'package:fresh_leaf/app/modules/cart/widgets/cart_summary_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/core/models/cart_snapshot.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CartService>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCartService mockCartService;

  setUp(() {
    mockCartService = MockCartService();
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> pumpCartView(
    WidgetTester tester, {
    CartSnapshot? snapshot,
  }) async {
    when(mockCartService.getCartSnapshot()).thenAnswer(
      (_) async =>
          snapshot ?? const CartSnapshot(
            items: [],
            totalDisplay: MoneyDisplay.empty,
          ),
    );

    final controller = CartController(cartService: mockCartService);
    Get.put<CartController>(controller);

    await tester.pumpWidget(
      GetMaterialApp(
        getPages: [
          GetPage(name: AppRoutes.cart, page: () => const CartView()),
          GetPage(name: AppRoutes.checkout, page: () => const Scaffold()),
        ],
        initialRoute: AppRoutes.cart,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('CartView - empty cart', () {
    testWidgets('shows CartEmptyWidget when cart is empty', (tester) async {
      await pumpCartView(tester);
      await tester.pump();

      expect(find.byType(CartEmptyWidget), findsOneWidget);
    });
  });

  group('CartView - with items', () {
    testWidgets('shows items and summary when cart has products', (
      tester,
    ) async {
      final cartItem = CartItem(
        id: 1,
        vendorInventoryId: 10,
        quantity: 2.0,
        subtotal: 10.0,
        subtotalDisplay: const MoneyDisplay(usd: 10.0, khr: 41000.0),
      );

      await pumpCartView(
        tester,
        snapshot: CartSnapshot(
          items: [cartItem],
          totalDisplay: const MoneyDisplay(usd: 10.0, khr: 41000.0),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CartSummaryWidget), findsOneWidget);
    });
  });
}
