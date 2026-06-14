import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/order_wallet_payment/controllers/order_wallet_payment_controller.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/models/wallet.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_wallet_payment_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<OrderService>(),
  MockSpec<ApiClient>(),
  MockSpec<StorageService>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Wallet makeWallet({int id = 1, double balance = 100, String code = 'USD', String name = 'US Dollar', String symbol = r'$'}) {
    return Wallet(
      id: id,
      balance: balance,
      currency: WalletCurrency(id: code == 'KHR' ? 1 : 2, code: code, name: name, symbol: symbol),
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
  }

  Order makeOrder({int id = 1, double totalAmount = 50, MoneyDisplay? totalDisplay}) {
    return Order(
      id: id,
      orderNumber: 'FL000$id',
      totalAmount: totalAmount,
      subtotal: totalAmount,
      totalAmountDisplay: totalDisplay ?? MoneyDisplay.empty,
    );
  }

  group('OrderWalletPaymentController', () {
    late MockOrderService mockOrderService;
    late MockApiClient mockApiClient;
    late MockStorageService mockStorageService;
    late OrderWalletPaymentController controller;

    setUp(() {
      mockOrderService = MockOrderService();
      mockApiClient = MockApiClient();
      mockStorageService = MockStorageService();
      Get.lazyPut<StorageService>(() => mockStorageService);
      controller = OrderWalletPaymentController(
        orderService: mockOrderService,
        apiClient: mockApiClient,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('canPay returns false when no orders and not checkout', () {
      expect(controller.canPay, isFalse);
    });

    test('canPay returns false when no wallet selected', () {
      controller.orderIds.assignAll([1]);
      expect(controller.canPay, isFalse);
    });

    test('canPay returns false when wallet balance insufficient', () {
      controller.orderIds.assignAll([1]);
      controller.orders.assignAll([
        makeOrder(id: 1, totalAmount: 100, totalDisplay: const MoneyDisplay(usd: 100, khr: 410000)),
      ]);

      controller.selectedWallet.value = makeWallet(balance: 50);

      expect(controller.canPay, isFalse);
    });

    test('canPay returns true when wallet balance sufficient', () {
      controller.orderIds.assignAll([1]);
      controller.orders.assignAll([
        makeOrder(id: 1, totalAmount: 50, totalDisplay: const MoneyDisplay(usd: 50, khr: 205000)),
      ]);

      controller.selectedWallet.value = makeWallet(balance: 100);

      expect(controller.canPay, isTrue);
    });

    test('canPay returns true with floating point precision edge case', () {
      controller.orderIds.assignAll([1]);
      controller.orders.assignAll([
        makeOrder(id: 1, totalAmount: 5.0, totalDisplay: const MoneyDisplay(usd: 5.0, khr: 20500)),
      ]);

      controller.selectedWallet.value = makeWallet(balance: 5.000000000000001);

      expect(controller.canPay, isTrue);
    });

    test('totalAmount returns 0 when no wallet selected', () {
      expect(controller.totalAmount, 0.0);
    });

    test('totalAmount returns sum of order totals for USD wallet', () {
      controller.orders.assignAll([
        makeOrder(id: 1, totalAmount: 25, totalDisplay: const MoneyDisplay(usd: 25, khr: 102500)),
        makeOrder(id: 2, totalAmount: 35, totalDisplay: const MoneyDisplay(usd: 35, khr: 143500)),
      ]);

      controller.selectedWallet.value = makeWallet(balance: 100);

      expect(controller.totalAmount, 60.0);
    });

    test('totalAmount uses KHR display for KHR wallet', () {
      controller.orders.assignAll([
        makeOrder(id: 1, totalAmount: 25, totalDisplay: const MoneyDisplay(usd: 25, khr: 102500)),
      ]);

      controller.selectedWallet.value = makeWallet(balance: 500000, code: 'KHR', name: 'Riel', symbol: '\u{17DB}');

      expect(controller.totalAmount, 102500.0);
    });

    test('totalDisplay returns empty when no orders and not checkout', () {
      expect(controller.totalDisplay, MoneyDisplay.empty);
    });

    test('totalDisplay sums order totals', () {
      controller.orders.assignAll([
        makeOrder(id: 1, totalAmount: 25, totalDisplay: const MoneyDisplay(usd: 25, khr: 102500)),
        makeOrder(id: 2, totalAmount: 35, totalDisplay: const MoneyDisplay(usd: 35, khr: 143500)),
      ]);

      final display = controller.totalDisplay;

      expect(display.usd, 60.0);
      expect(display.khr, 246000.0);
    });

    test('totalDisplay uses checkout args when isCheckout', () {
      controller.isCheckout = true;
      controller.checkoutArgs = <String, dynamic>{
        'amount_usd': 25.50,
        'amount_khr': 104550,
      };

      final display = controller.totalDisplay;

      expect(display.usd, 25.50);
      expect(display.khr, 104550);
    });

    test('getAmountForWallet returns 0 for null wallet', () {
      expect(controller.getAmountForWallet(null), 0.0);
    });

    test('getAmountForWallet uses checkout args when isCheckout', () {
      controller.isCheckout = true;
      controller.checkoutArgs = <String, dynamic>{
        'amount_usd': 25.50,
        'amount_khr': 104550,
      };

      final usdWallet = makeWallet(code: 'USD');
      final khrWallet = makeWallet(code: 'KHR', name: 'Riel', symbol: '\u{17DB}');

      expect(controller.getAmountForWallet(usdWallet), 25.50);
      expect(controller.getAmountForWallet(khrWallet), 104550);
    });

    test('updateSelectedWallet updates selected wallet', () {
      final wallet1 = makeWallet(id: 1, balance: 100);
      final wallet2 = makeWallet(id: 2, balance: 200);

      controller.updateSelectedWallet(wallet1);
      expect(controller.selectedWallet.value, wallet1);

      controller.updateSelectedWallet(wallet2);
      expect(controller.selectedWallet.value, wallet2);
    });

    test('updateSelectedWallet ignores same wallet', () {
      final wallet = makeWallet(id: 1, balance: 100);

      controller.updateSelectedWallet(wallet);
      controller.updateSelectedWallet(wallet);

      expect(controller.selectedWallet.value, wallet);
    });
  });
}
