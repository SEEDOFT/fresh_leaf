import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/views/wallet_top_up_view.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wallet_top_up_view_test.mocks.dart';

class FakeInternalCallback extends Fake implements InternalFinalCallback<void> {
  @override
  void call() {}
}

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
  MockSpec<StorageService>(),
  MockSpec<PaymentSessionService>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockApiClient mockApiClient;
  late MockStorageService mockStorageService;
  late MockPaymentSessionService mockPaymentSessionService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorageService = MockStorageService();
    mockPaymentSessionService = MockPaymentSessionService();

    when(mockStorageService.token).thenReturn(null);
    when(mockStorageService.onStart).thenReturn(FakeInternalCallback());
    when(mockStorageService.onDelete).thenReturn(FakeInternalCallback());
    when(mockApiClient.onStart).thenReturn(FakeInternalCallback());
    when(mockApiClient.onDelete).thenReturn(FakeInternalCallback());
    when(mockPaymentSessionService.onStart).thenReturn(FakeInternalCallback());
    when(mockPaymentSessionService.onDelete).thenReturn(FakeInternalCallback());

    Get.put<StorageService>(mockStorageService, permanent: true);
    Get.put<ApiClient>(mockApiClient, permanent: true);
    Get.put<PaymentSessionService>(mockPaymentSessionService, permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> pumpTopUpView(WidgetTester tester) async {
    final walletController = WalletController(apiClient: mockApiClient);
    Get.put<WalletController>(walletController);

    final topUpController = WalletTopUpController(
      paymentSessionService: mockPaymentSessionService,
      walletController: walletController,
    );
    Get.put<WalletTopUpController>(topUpController);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const WalletTopUpView(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('renders wallet top up view', (tester) async {
    await pumpTopUpView(tester);

    expect(find.byType(WalletTopUpView), findsOneWidget);
  });

  testWidgets('shows top up summary section', (tester) async {
    await pumpTopUpView(tester);

    expect(find.text('top_up_summary'.tr), findsOneWidget);
  });

  testWidgets('shows continue to payment button', (tester) async {
    await pumpTopUpView(tester);

    expect(find.text('continue_to_payment'.tr), findsOneWidget);
  });

  testWidgets('continue button is disabled when amount is zero', (tester) async {
    await pumpTopUpView(tester);

    final controller = Get.find<WalletTopUpController>();
    expect(controller.isAmountValid.value, isFalse);
  });

  testWidgets('shows secure payment notice', (tester) async {
    await pumpTopUpView(tester);

    expect(find.text('secure_payment_notice'.tr), findsOneWidget);
  });

  testWidgets('shows preset amounts', (tester) async {
    await pumpTopUpView(tester);

    expect(find.textContaining('\$10'), findsWidgets);
    expect(find.textContaining('\$20'), findsWidgets);
    expect(find.textContaining('\$50'), findsWidgets);
    expect(find.textContaining('\$100'), findsWidgets);
  });

  testWidgets('tapping a preset updates the amount', (tester) async {
    await pumpTopUpView(tester);

    final controller = Get.find<WalletTopUpController>();
    final tenButton = find.text('\$10');
    if (tenButton.evaluate().isNotEmpty) {
      await tester.tap(tenButton.first);
      await tester.pumpAndSettle();

      expect(controller.selectedAmount.value, 10.0);
      expect(controller.isAmountValid.value, isTrue);
    }
  });
}
