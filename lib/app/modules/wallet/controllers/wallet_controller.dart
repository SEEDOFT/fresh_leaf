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
    required this.isCredit,
    String? status,
  }) : status = status ?? 'success'.tr;

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCredit;
  final String status;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    final typeMap = json['type'] as Map<String, dynamic>?;
    final typeId = typeMap?['id'] as int?;
    final typeName = typeMap?['name']?.toString() ?? 'Transaction';

    final isCredit = typeId == 1 || typeId == 4; // 1=Deposit, 4=Refund

    final statusMap = json['status'] as Map<String, dynamic>?;
    final statusName = statusMap?['name']?.toString() ?? 'success'.tr;

    return WalletTransaction(
      id: json['id'].toString(),
      title: json['description']?.toString() ?? typeName,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      date: DateTime.tryParse(json['created_at'].toString())?.toLocal() ?? DateTime.now(),
      isCredit: isCredit,
      status: statusName,
    );
  }
}

class WalletController extends GetxController {
  static const List<String> supportedCurrencies = ['KHR', 'USD'];

  final RxString selectedCurrency = 'KHR'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isBalanceVisible = true.obs;

  final RxDouble khrBalance = 0.0.obs;
  final RxDouble usdBalance = 0.0.obs;

  final RxList<WalletTransaction> khrTransactions = <WalletTransaction>[].obs;
  final RxList<WalletTransaction> usdTransactions = <WalletTransaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ProfileController>()) {
      applyWallets(Get.find<ProfileController>().wallets);
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

    if (khrBalance.value == 0.0 && usdBalance.value == 0.0) {
      isLoading.value = true;
    }
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.userWallets);
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

      applyWallets(apiResponse.data);
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

  Future<void> fetchTransactions(int walletId, String currencyCode) async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(
        ApiEndpoints.walletTransactions,
        queryParameters: {'wallet_id': walletId},
      );

      final responseData = response.data as Map<String, dynamic>?;
      final data = responseData?['data'];
      if (data != null && data is List) {
        final transactions = data
            .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
            .toList();

        if (currencyCode == 'USD') {
          usdTransactions.value = transactions;
        } else if (currencyCode == 'KHR') {
          khrTransactions.value = transactions;
        }
      }
    } catch (_) {
      // Silently ignore transaction fetch errors
    }
  }

  void applyWallets(List<Wallet> wallets) {
    var nextUsdBalance = 0.0;
    var nextKhrBalance = 0.0;
    var hasUsd = false;
    var hasKhr = false;

    for (final wallet in wallets) {
      final currencyCode = wallet.currency.code.toUpperCase();
      if (currencyCode == 'USD') {
        nextUsdBalance = wallet.balance;
        hasUsd = true;
        fetchTransactions(wallet.id, 'USD');
      } else if (currencyCode == 'KHR') {
        nextKhrBalance = wallet.balance;
        hasKhr = true;
        fetchTransactions(wallet.id, 'KHR');
      }
    }

    usdBalance.value = hasUsd ? nextUsdBalance : 0.0;
    khrBalance.value = hasKhr ? nextKhrBalance : 0.0;
  }
}
