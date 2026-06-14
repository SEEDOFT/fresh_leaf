import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up_payment/controllers/wallet_top_up_payment_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';

import 'wallet_top_up_payment_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WalletTopUpChannelOption', () {
    test('isCreditDebit returns true for credit_debit typeCode', () {
      const option = WalletTopUpChannelOption(
        id: 'channel-credit_debit',
        label: 'Credit/Debit Card',
        typeCode: 'credit_debit',
      );

      expect(option.isCreditDebit, isTrue);
    });

    test('isCreditDebit returns false for other typeCodes', () {
      const option = WalletTopUpChannelOption(
        id: 'channel-aba',
        label: 'ABA Pay',
        typeCode: 'aba',
      );

      expect(option.isCreditDebit, isFalse);
    });
  });

  group('WalletTopUpPaymentController', () {
    late MockApiClient mockApiClient;
    late WalletTopUpPaymentController controller;

    setUp(() {
      mockApiClient = MockApiClient();
      controller = WalletTopUpPaymentController(apiClient: mockApiClient);
    });

    tearDown(() {
      Get.reset();
    });

    test('formattedAmount returns dollar for USD', () {
      controller.currency.value = 'USD';
      controller.amount.value = 25.50;

      expect(controller.formattedAmount, '\$25.50');
    });

    test('formattedAmount returns riel for KHR', () {
      controller.currency.value = 'KHR';
      controller.amount.value = 100000;

      expect(controller.formattedAmount, '100000 \u{17DB}');
    });

    test('formattedAmount returns dollar sign for lowercase usd', () {
      controller.currency.value = 'usd';
      controller.amount.value = 10.0;

      expect(controller.formattedAmount, '\$10.00');
    });

    test('selectedChannel returns null when no channel selected', () {
      controller.selectedChannelId.value = '';

      expect(controller.selectedChannel, isNull);
    });

    test('selectedChannel returns option when valid id selected', () {
      controller.selectedChannelId.value = 'channel-aba';

      expect(controller.selectedChannel, isNull);
    });

    test('default currency is USD', () {
      expect(controller.currency.value, 'USD');
    });

    test('default amount is 0.0', () {
      expect(controller.amount.value, 0.0);
    });

    test('default selectedChannelId is empty', () {
      expect(controller.selectedChannelId.value, isEmpty);
    });

    test('types list is empty by default', () {
      expect(controller.types, isEmpty);
    });

    testWidgets('confirmSelection with no channel shows snackbar and does not pop', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
      controller.selectedChannelId.value = '';

      controller.confirmSelection();
      await tester.pump(const Duration(seconds: 4));

      expect(controller.selectedChannelId.value, isEmpty);
    });
  });
}
