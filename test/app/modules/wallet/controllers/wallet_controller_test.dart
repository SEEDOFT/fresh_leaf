import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/core/models/wallet.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wallet_controller_test.mocks.dart';

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

  WalletCurrency makeCurrency({int id = 2, String code = 'USD', String name = 'US Dollar', String symbol = r'$'}) {
    return WalletCurrency(id: id, code: code, name: name, symbol: symbol);
  }

  Wallet makeWallet({int id = 1, double balance = 0, WalletCurrency? currency}) {
    return Wallet(
      id: id,
      balance: balance,
      currency: currency ?? makeCurrency(),
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
  }

  dio.Response<Map<String, dynamic>> emptyTransactionsResponse() {
    return dio.Response(
      requestOptions: dio.RequestOptions(path: ''),
      data: {
        'status': 'success',
        'data': {'data': [], 'current_page': 1, 'last_page': 1, 'per_page': 15, 'total': 0},
      },
    );
  }

  group('WalletTransaction', () {
    test('fromJson parses full map correctly', () {
      final transaction = WalletTransaction.fromJson({
        'id': 42,
        'description': 'Top up via ABA',
        'amount': 25.50,
        'created_at': '2026-01-15T10:30:00Z',
        'type': {'id': 1, 'name': 'Deposit'},
        'status': {'id': 2, 'name': 'Completed'},
      });

      expect(transaction.id, '42');
      expect(transaction.title, 'Top up via ABA');
      expect(transaction.amount, 25.50);
      expect(transaction.typeId, 1);
      expect(transaction.statusId, 2);
    });

    test('fromJson falls back to type name when description is null', () {
      final transaction = WalletTransaction.fromJson({
        'id': 1,
        'description': null,
        'amount': 10,
        'created_at': null,
        'type': {'id': 3, 'name': 'Payment'},
        'status': null,
      });

      expect(transaction.title, 'Payment');
      expect(transaction.typeId, 3);
      expect(transaction.statusId, 2);
    });

    test('fromJson defaults when type and status maps are null', () {
      final transaction = WalletTransaction.fromJson({
        'id': 1,
        'amount': 'invalid',
      });

      expect(transaction.id, '1');
      expect(transaction.amount, 0.0);
      expect(transaction.typeId, 0);
      expect(transaction.statusId, 2);
    });

    test('isCredit returns true for deposit and refund', () {
      final deposit = WalletTransaction(
        id: '1', title: 'Deposit', amount: 100, date: DateTime.now(), typeId: 1, statusId: 2,
      );
      final refund = WalletTransaction(
        id: '2', title: 'Refund', amount: 50, date: DateTime.now(), typeId: 4, statusId: 2,
      );
      final withdrawal = WalletTransaction(
        id: '3', title: 'Withdrawal', amount: 30, date: DateTime.now(), typeId: 2, statusId: 2,
      );

      expect(deposit.isCredit, isTrue);
      expect(refund.isCredit, isTrue);
      expect(withdrawal.isCredit, isFalse);
    });

    test('status returns correct label based on statusId', () {
      final pending = WalletTransaction(
        id: '1', title: 'T', amount: 10, date: DateTime.now(), typeId: 1, statusId: 1,
      );
      final completed = WalletTransaction(
        id: '2', title: 'T', amount: 10, date: DateTime.now(), typeId: 1, statusId: 2,
      );
      final failed = WalletTransaction(
        id: '3', title: 'T', amount: 10, date: DateTime.now(), typeId: 1, statusId: 3,
      );
      final cancelled = WalletTransaction(
        id: '4', title: 'T', amount: 10, date: DateTime.now(), typeId: 1, statusId: 4,
      );
      final unknown = WalletTransaction(
        id: '5', title: 'T', amount: 10, date: DateTime.now(), typeId: 1, statusId: 99,
      );

      expect(pending.status, 'pending'.tr);
      expect(completed.status, 'success'.tr);
      expect(failed.status, 'failed'.tr);
      expect(cancelled.status, 'cancelled'.tr);
      expect(unknown.status, 'success'.tr);
    });
  });

  group('WalletController', () {
    late MockApiClient mockApiClient;
    late MockStorageService mockStorageService;
    late WalletController controller;

    setUp(() {
      mockApiClient = MockApiClient();
      mockStorageService = MockStorageService();
      when(mockStorageService.onStart).thenReturn(FakeInternalCallback());
      when(mockStorageService.onDelete).thenReturn(FakeInternalCallback());
      Get.put<StorageService>(mockStorageService, permanent: true);
      controller = WalletController(apiClient: mockApiClient);
    });

    tearDown(() {
      Get.reset();
    });

    test('setCurrency sets valid currency', () {
      controller.setCurrency('USD');
      expect(controller.selectedCurrency.value, 'USD');

      controller.setCurrency('KHR');
      expect(controller.selectedCurrency.value, 'KHR');
    });

    test('setCurrency ignores invalid currency', () {
      controller.setCurrency('KHR');
      controller.setCurrency('EUR');
      expect(controller.selectedCurrency.value, 'KHR');
    });

    test('toggleBalanceVisibility toggles value', () {
      expect(controller.isBalanceVisible.value, isTrue);
      controller.toggleBalanceVisibility();
      expect(controller.isBalanceVisible.value, isFalse);
      controller.toggleBalanceVisibility();
      expect(controller.isBalanceVisible.value, isTrue);
    });

    test('activeBalance returns usd balance when USD selected', () {
      controller.selectedCurrency.value = 'USD';
      controller.usdBalance.value = 50.0;
      expect(controller.activeBalance.value, 50.0);
    });

    test('activeBalance returns khr balance when KHR selected', () {
      controller.selectedCurrency.value = 'KHR';
      controller.khrBalance.value = 100000.0;
      expect(controller.activeBalance.value, 100000.0);
    });

    test('activeSymbol returns dollar for USD', () {
      controller.selectedCurrency.value = 'USD';
      expect(controller.activeSymbol, r'$');
    });

    test('activeSymbol returns riel for KHR', () {
      controller.selectedCurrency.value = 'KHR';
      expect(controller.activeSymbol, '\u{17DB}');
    });

    test('activeTransactions returns usd list when USD selected', () {
      controller.selectedCurrency.value = 'USD';
      expect(controller.activeTransactions, controller.usdTransactions);
    });

    test('activeTransactions returns khr list when KHR selected', () {
      controller.selectedCurrency.value = 'KHR';
      expect(controller.activeTransactions, controller.khrTransactions);
    });

    test('activeHasMore returns usdHasMore when USD selected', () {
      controller.selectedCurrency.value = 'USD';
      controller.usdHasMore.value = false;
      expect(controller.activeHasMore.value, isFalse);
    });

    test('applyWallets sets balances from wallet list', () async {
      when(mockApiClient.getRequest(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => emptyTransactionsResponse());

      final wallets = <Wallet>[
        makeWallet(id: 1, balance: 100.0, currency: makeCurrency(id: 1, code: 'KHR', name: 'Riel', symbol: '\u{17DB}')),
        makeWallet(id: 2, balance: 50.0, currency: makeCurrency(id: 2, code: 'USD', name: 'US Dollar', symbol: r'$')),
      ];

      await controller.applyWallets(wallets);

      expect(controller.khrBalance.value, 100.0);
      expect(controller.usdBalance.value, 50.0);
      expect(controller.hasLoadedWallets.value, isTrue);
    });

    test('applyWallets sets zero balance for missing currencies', () async {
      when(mockApiClient.getRequest(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => emptyTransactionsResponse());

      final wallets = <Wallet>[
        makeWallet(id: 1, balance: 100.0, currency: makeCurrency(id: 2, code: 'USD', name: 'US Dollar', symbol: r'$')),
      ];

      await controller.applyWallets(wallets);

      expect(controller.khrBalance.value, 0.0);
      expect(controller.usdBalance.value, 100.0);
    });

    test('fetchWallets returns early when token is null', () async {
      when(mockStorageService.token).thenReturn(null);

      await controller.fetchWallets();

      verifyNever(mockApiClient.getRequest(any));
    });

    test('fetchWallets returns early when token is empty', () async {
      when(mockStorageService.token).thenReturn('');

      await controller.fetchWallets();

      verifyNever(mockApiClient.getRequest(any));
    });

    test('fetchWallets returns early when already loading', () async {
      when(mockStorageService.token).thenReturn('test-token');
      controller.isLoading.value = true;

      await controller.fetchWallets();

      verifyNever(mockApiClient.getRequest(any));
    });

    test('refreshWallets sets isRefreshing', () async {
      when(mockStorageService.token).thenReturn(null);

      expect(controller.isRefreshing.value, isFalse);
      final future = controller.refreshWallets();
      expect(controller.isRefreshing.value, isTrue);
      await future;
      expect(controller.isRefreshing.value, isFalse);
    });

    test('supportedCurrencies contains KHR and USD', () {
      expect(WalletController.supportedCurrencies, containsAll(['KHR', 'USD']));
    });
  });
}
