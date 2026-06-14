import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wallet_top_up_controller_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PaymentSessionService>(),
  MockSpec<WalletController>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletTopUpController', () {
    late MockPaymentSessionService mockPaymentSessionService;
    late MockWalletController mockWalletController;
    late WalletTopUpController controller;

    setUp(() {
      mockPaymentSessionService = MockPaymentSessionService();
      mockWalletController = MockWalletController();
      controller = WalletTopUpController(
        paymentSessionService: mockPaymentSessionService,
        walletController: mockWalletController,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('selectPreset sets amount and validates', () {
      controller.selectPreset(50.0);

      expect(controller.selectedAmount.value, 50.0);
      expect(controller.isAmountValid.value, isTrue);
      expect(controller.amountController.text, '50');
    });

    test('selectPreset with decimal amount formats correctly', () {
      controller.selectPreset(10.50);

      expect(controller.selectedAmount.value, 10.50);
      expect(controller.amountController.text, '10.5');
    });

    test('selectPreset with zero amount is invalid', () {
      controller.selectPreset(0);

      expect(controller.selectedAmount.value, 0.0);
      expect(controller.isAmountValid.value, isFalse);
    });

    test('formattedAmount returns dollar for USD', () {
      controller.selectedCurrency.value = 'USD';
      controller.selectedAmount.value = 25.50;

      expect(controller.formattedAmount, '\$25.50');
    });

    test('formattedAmount returns riel for KHR', () {
      controller.selectedCurrency.value = 'KHR';
      controller.selectedAmount.value = 100000;

      expect(controller.formattedAmount, '100000 \u{17DB}');
    });

    test('syncAmountFromInput updates selectedAmount and isAmountValid', () {
      controller.onInit();
      controller.amountController.text = '75';
      expect(controller.selectedAmount.value, 75.0);
      expect(controller.isAmountValid.value, isTrue);
    });

    test('syncAmountFromInput with empty text sets zero and invalid', () {
      controller.onInit();
      controller.amountController.text = '50';
      controller.amountController.text = '';

      expect(controller.selectedAmount.value, 0.0);
      expect(controller.isAmountValid.value, isFalse);
    });

    test('syncAmountFromInput with invalid text sets zero', () {
      controller.onInit();
      controller.amountController.text = 'abc';

      expect(controller.selectedAmount.value, 0.0);
      expect(controller.isAmountValid.value, isFalse);
    });

    test('default selectedCurrency is USD', () {
      expect(controller.selectedCurrency.value, 'USD');
    });

    test('usdPresets contains expected values', () {
      expect(controller.usdPresets, [10, 20, 50, 100]);
    });

    test('khrPresets contains expected values', () {
      expect(controller.khrPresets, [50000, 100000, 200000, 500000]);
    });
  });
}
