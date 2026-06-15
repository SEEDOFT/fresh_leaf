import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/constants/payment_method_type_codes.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
// import 'package:fresh_leaf/core/models/payment_session.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';

class WalletTopUpController extends GetxController {
  WalletTopUpController({
    required PaymentSessionService paymentSessionService,
    required WalletController walletController,
    required ApiClient apiClient,
  }) : _paymentSessionService = paymentSessionService,
       _walletController = walletController,
       _apiClient = apiClient;

  final PaymentSessionService _paymentSessionService;
  final WalletController _walletController;
  final ApiClient _apiClient;
  final amountController = TextEditingController();
  final RxString selectedCurrency = 'USD'.obs;
  final RxDouble selectedAmount = 0.0.obs;
  final RxBool isAmountValid = false.obs;
  final RxBool isLoading = false.obs;

  final List<double> usdPresets = [10, 20, 50, 100];
  final List<double> khrPresets = [50000, 100000, 200000, 500000];

  String get formattedAmount {
    if (selectedCurrency.value == 'USD') {
      return '\$${formatPrice(selectedAmount.value)}';
    }
    return '${selectedAmount.value.toInt()} ៛';
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String) {
      selectedCurrency.value = args;
    }
    amountController.addListener(_syncAmountFromInput);
  }

  void selectPreset(double amount) {
    selectedAmount.value = amount;
    isAmountValid.value = amount > 0;
    amountController.text = amount % 1 == 0
        ? amount.toInt().toString()
        : amount.toString();
  }

  Future<void> openPaymentSelection() async {
    final amountText = amountController.text.trim();
    if (amountText.isEmpty) {
      Get.snackbar(
        'validation_invalid_amount'.tr,
        'validation_amount_required'.tr,
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'validation_invalid_amount'.tr,
        'validation_invalid_amount'.tr,
      );
      return;
    }

    final routeResult = await Get.toNamed<dynamic>(
      AppRoutes.walletTopUpPayment,
      arguments: <String, dynamic>{
        'currency': selectedCurrency.value,
        'amount': amount,
      },
    );

    final paymentMethod = _toPaymentMethod(routeResult);
    if (paymentMethod == null) return;

    await completeTopUpAfterSelection(paymentMethod, amount);
  }

  Future<void> completeTopUpAfterSelection(
    PaymentMethod method,
    double amount,
  ) async {
    isLoading.value = true;
    try {
      await _applyTopUpResult(method: method, amount: amount);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _applyTopUpResult({
    required PaymentMethod method,
    required double amount,
  }) async {
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.walletTopUpSeed,
        data: {
          'amount': amount,
          'currency': selectedCurrency.value,
        },
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      if (apiResponse.isSuccess) {
        await _walletController.fetchWallets();
        await Get.offNamed<void>(
          AppRoutes.walletTopUpSuccess,
          arguments: <String, dynamic>{
            'amount': amount,
            'currency': selectedCurrency.value,
          },
        );
      } else {
        throw Exception(apiResponse.status.message);
      }
    } on Exception {
      Get.snackbar(
        'top_up_failed'.tr,
        'unable_process_payment'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
        borderRadius: 14,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  String _resolveTypeCode(PaymentMethod method) {
    final code = (method.paymentMethodType?.code ?? '').trim().toLowerCase();
    if (code.isNotEmpty) return code;
    return PaymentMethodTypeCodes.creditDebit;
  }

  void _syncAmountFromInput() {
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    selectedAmount.value = amount;
    isAmountValid.value = amount > 0;
  }

  PaymentMethod? _toPaymentMethod(dynamic value) {
    if (value is PaymentMethod) return value;
    if (value is Map<String, dynamic>) return PaymentMethod.fromMap(value);
    if (value is Map) {
      final mapped = value.map<String, dynamic>(
        (key, item) => MapEntry<String, dynamic>(key.toString(), item),
      );
      return PaymentMethod.fromMap(mapped);
    }
    return null;
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
