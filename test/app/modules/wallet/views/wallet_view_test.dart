import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/views/wallet_view.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wallet_view_test.mocks.dart';

class FakeInternalCallback extends Fake implements InternalFinalCallback<void> {
  @override
  void call() {}
}

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
  MockSpec<StorageService>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockApiClient mockApiClient;
  late MockStorageService mockStorageService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorageService = MockStorageService();
    when(mockStorageService.token).thenReturn(null);
    when(mockStorageService.onStart).thenReturn(FakeInternalCallback());
    when(mockStorageService.onDelete).thenReturn(FakeInternalCallback());
    when(mockApiClient.onStart).thenReturn(FakeInternalCallback());
    when(mockApiClient.onDelete).thenReturn(FakeInternalCallback());

    Get.put<StorageService>(mockStorageService, permanent: true);
    Get.put<ApiClient>(mockApiClient, permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> pumpWalletView(WidgetTester tester) async {
    final controller = WalletController(apiClient: mockApiClient);
    Get.put<WalletController>(controller);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const WalletView(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('renders wallet view with currency tabs', (tester) async {
    await pumpWalletView(tester);

    expect(find.byType(WalletView), findsOneWidget);
    expect(find.text('KHR'), findsWidgets);
    expect(find.text('USD'), findsWidgets);
  });

  testWidgets('tapping USD tab switches currency', (tester) async {
    await pumpWalletView(tester);

    final controller = Get.find<WalletController>();
    expect(controller.selectedCurrency.value, 'KHR');

    await tester.tap(find.text('USD'));
    await tester.pumpAndSettle();

    expect(controller.selectedCurrency.value, 'USD');
  });

  testWidgets('tapping KHR tab switches currency back', (tester) async {
    await pumpWalletView(tester);

    final controller = Get.find<WalletController>();
    controller.selectedCurrency.value = 'USD';
    await tester.pump();

    await tester.tap(find.text('KHR'));
    await tester.pumpAndSettle();

    expect(controller.selectedCurrency.value, 'KHR');
  });

  testWidgets('renders balance card with current balance text', (tester) async {
    await pumpWalletView(tester);

    expect(find.text('current_balance'.tr), findsOneWidget);
  });

  testWidgets('shows no transactions when list is empty', (tester) async {
    await pumpWalletView(tester);

    expect(find.text('no_transactions'.tr), findsOneWidget);
  });

  testWidgets('shows transaction history header', (tester) async {
    await pumpWalletView(tester);

    expect(find.text('transaction_history'.tr), findsWidgets);
  });
}
