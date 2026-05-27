import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/payment_method_type_codes.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/core/models/payment_session.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletTopUpController extends GetxController {
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
      Get.snackbar('invalid_amount'.tr, 'enter_amount'.tr);
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar('invalid_amount'.tr, 'enter_valid_amount'.tr);
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
    final typeCode = _resolveTypeCode(method);
    final sessionService = Get.find<PaymentSessionService>();
    isLoading.value = true;
    try {
      final session = await sessionService.createTopUpSession(
        amount: amount,
        currency: selectedCurrency.value,
        paymentMethodTypeCode: typeCode,
        paymentMethodId: (method.id ?? 0) > 0 ? method.id : null,
      );
      final shouldContinue = await _handleSessionForTopUp(
        session: session,
        typeCode: typeCode,
      );
      if (!shouldContinue) return;
      await _applyTopUpResult(method: method, amount: amount);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _handleSessionForTopUp({
    required PaymentSession session,
    required String typeCode,
  }) async {
    final isRedirectType =
        typeCode == PaymentMethodTypeCodes.aba ||
        typeCode == PaymentMethodTypeCodes.acleda;
    if (!isRedirectType) return true;

    final redirected = await _tryOpenRedirect(session.redirectUrl);
    if (redirected) {
      Get.snackbar('success'.tr, 'redirecting_to_bank_app'.tr);
    }

    final paid = await Get.toNamed<bool>(
      AppRoutes.paymentQr,
      arguments: <String, dynamic>{
        'session': session.toMap(),
      },
    );
    return paid ?? false;
  }

  Future<bool> _tryOpenRedirect(String? url) async {
    if ((url ?? '').isEmpty) return false;
    final uri = Uri.tryParse(url!);
    if (uri == null) return false;
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _applyTopUpResult({
    required PaymentMethod method,
    required double amount,
  }) async {
    // Simulate payment processing
    await Future<void>.delayed(const Duration(seconds: 2));

    // Update WalletController balance
    if (Get.isRegistered<WalletController>()) {
      final walletCtrl = Get.find<WalletController>();
      if (selectedCurrency.value == 'USD') {
        walletCtrl.usdBalance.value += amount;
        walletCtrl.usdTransactions.insert(
          0,
          WalletTransaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: '${'top_up_mock'.tr} (${method.label ?? 'Card'})',
            amount: amount,
            date: DateTime.now(),
            isCredit: true,
          ),
        );
      } else {
        walletCtrl.khrBalance.value += amount;
        walletCtrl.khrTransactions.insert(
          0,
          WalletTransaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: '${'top_up_mock'.tr} (${method.label ?? 'Card'})',
            amount: amount,
            date: DateTime.now(),
            isCredit: true,
          ),
        );
      }
    }

    Get.back<void>();
    final sym = selectedCurrency.value == 'KHR' ? '' : r'$';
    final label = selectedCurrency.value == 'KHR' ? ' ៛' : '';
    Get.snackbar(
      'success'.tr,
      'top_up_success'.trParams({
        'amount': '$sym${amountController.text.trim()}$label',
      }),
    );
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
