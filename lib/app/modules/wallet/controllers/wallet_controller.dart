import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/wallet.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class WalletTransaction {
  WalletTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.typeId,
    required this.statusId,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    final createdAt = toNullableDateTime(json['created_at']);
    final typeMap = json['type'] as Map<String, dynamic>?;
    final typeId = typeMap?['id'] as int? ?? 0;
    final typeName = typeMap?['name']?.toString() ?? 'Transaction';

    final statusMap = json['status'] as Map<String, dynamic>?;
    final statusId = statusMap?['id'] as int? ?? 2; // 2 = Completed

    return WalletTransaction(
      id: json['id'].toString(),
      title: json['description']?.toString() ?? typeName,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      date: createdAt ?? DateTime.now(),
      typeId: typeId,
      statusId: statusId,
    );
  }

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final int typeId;
  final int statusId;

  // 1=Deposit, 2=Withdrawal, 3=Payment, 4=Refund
  bool get isCredit => typeId == 1 || typeId == 4;

  // 1=Pending, 2=Completed, 3=Failed, 4=Cancelled
  String get status {
    return switch (statusId) {
      1 => 'pending'.tr,
      2 => 'success'.tr,
      3 => 'failed'.tr,
      4 => 'cancelled'.tr,
      _ => 'success'.tr,
    };
  }
}

class WalletController extends GetxController {
  static const List<String> supportedCurrencies = ['KHR', 'USD'];
  final ApiClient _apiClient = Get.find<ApiClient>();

  final RxString selectedCurrency = 'KHR'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isBalanceVisible = true.obs;

  final RxDouble khrBalance = 0.0.obs;
  final RxDouble usdBalance = 0.0.obs;

  final RxList<WalletTransaction> khrTransactions = <WalletTransaction>[].obs;
  final RxList<WalletTransaction> usdTransactions = <WalletTransaction>[].obs;

  final RxBool khrHasMore = true.obs;
  final RxBool usdHasMore = true.obs;
  final RxBool isLoadingMoreTransactions = false.obs;
  final RxBool hasLoadedWallets = false.obs;

  int _khrPage = 1;
  int _usdPage = 1;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.isRegistered<ProfileController>()) {
      await applyWallets(Get.find<ProfileController>().wallets);
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    if (!Get.isRegistered<ApiClient>()) return;
    await fetchWallets(showError: false);
  }

  RxDouble get activeBalance =>
      selectedCurrency.value == 'USD' ? usdBalance : khrBalance;

  RxList<WalletTransaction> get activeTransactions =>
      selectedCurrency.value == 'USD' ? usdTransactions : khrTransactions;

  RxBool get activeHasMore =>
      selectedCurrency.value == 'USD' ? usdHasMore : khrHasMore;

  String get activeSymbol => selectedCurrency.value == 'USD' ? r'$' : '៛';

  void setCurrency(String currency) {
    if (supportedCurrencies.contains(currency)) {
      selectedCurrency.value = currency;
    }
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
  }

  Future<void> refreshWallets() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      await fetchWallets();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> fetchWallets({bool showError = true}) async {
    if (isLoading.value) return;
    if (!Get.isRegistered<ApiClient>()) return;

    if (!hasLoadedWallets.value) {
      isLoading.value = true;
    }
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.wallets);
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        Wallet.listFromDynamic,
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        if (showError) {
          Get.snackbar(
            'fetch_failed'.tr,
            apiResponse.status.message.isNotEmpty
                ? apiResponse.status.message
                : 'unable_load_wallets'.tr,
          );
        }
        return;
      }

      await applyWallets(apiResponse.data);
    } on DioException catch (error) {
      if (showError) {
        Get.snackbar(
          'fetch_failed'.tr,
          parseApiErrorMessage(
            error,
            fallback: 'unable_load_wallets'.tr,
          ),
        );
      }
    } on Exception {
      if (showError) {
        Get.snackbar('fetch_failed'.tr, 'unable_load_wallets'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactions({
    required int walletId,
    required String currencyCode,
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.walletTransactions,
        queryParameters: {
          'wallet_id': walletId,
          'page': page,
        },
      );

      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        WalletTransaction.fromJson,
      );

      if (apiResponse.isSuccess) {
        final transactions = apiResponse.data.items;

        if (currencyCode == 'USD') {
          if (page == 1) {
            usdTransactions.assignAll(transactions);
            _usdPage = 1;
          } else {
            usdTransactions.addAll(transactions);
            _usdPage = page;
          }
          usdHasMore.value = apiResponse.data.hasMore;
        } else if (currencyCode == 'KHR') {
          if (page == 1) {
            khrTransactions.assignAll(transactions);
            _khrPage = 1;
          } else {
            khrTransactions.addAll(transactions);
            _khrPage = page;
          }
          khrHasMore.value = apiResponse.data.hasMore;
        }
      }
    } on Exception {
      // Silently ignore transaction fetch errors
    }
  }

  Future<void> loadMoreTransactions() async {
    if (isLoadingMoreTransactions.value) return;

    final isUsd = selectedCurrency.value == 'USD';
    final hasMore = isUsd ? usdHasMore.value : khrHasMore.value;
    if (!hasMore) return;

    final profileController = Get.find<ProfileController>();
    final wallets = profileController.wallets;
    final wallet = wallets.firstWhereOrNull(
      (w) => w.currency.code.toUpperCase() == selectedCurrency.value,
    );

    if (wallet == null) return;

    isLoadingMoreTransactions.value = true;
    try {
      final nextPage = isUsd ? _usdPage + 1 : _khrPage + 1;
      await fetchTransactions(
        walletId: wallet.id,
        currencyCode: selectedCurrency.value,
        page: nextPage,
      );
    } finally {
      isLoadingMoreTransactions.value = false;
    }
  }

  Future<void> applyWallets(List<Wallet> wallets) async {
    var nextUsdBalance = 0.0;
    var nextKhrBalance = 0.0;
    var hasUsd = false;
    var hasKhr = false;

    for (final wallet in wallets) {
      final currencyCode = wallet.currency.code.toUpperCase();
      if (currencyCode == 'USD') {
        nextUsdBalance = wallet.balance;
        hasUsd = true;
        await fetchTransactions(walletId: wallet.id, currencyCode: 'USD');
      } else if (currencyCode == 'KHR') {
        nextKhrBalance = wallet.balance;
        hasKhr = true;
        await fetchTransactions(walletId: wallet.id, currencyCode: 'KHR');
      }
    }

    usdBalance.value = hasUsd ? nextUsdBalance : 0.0;
    khrBalance.value = hasKhr ? nextKhrBalance : 0.0;
    hasLoadedWallets.value = true;
  }
}
