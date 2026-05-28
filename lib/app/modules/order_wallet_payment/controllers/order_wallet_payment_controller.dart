import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/models/wallet.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class OrderWalletPaymentController extends GetxController {
  final RxInt orderId = 0.obs;
  final Rxn<Order> order = Rxn<Order>();
  final RxList<Wallet> wallets = <Wallet>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isPaying = false.obs;

  final Rxn<Wallet> selectedWallet = Rxn<Wallet>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      orderId.value = args['order_id'] as int? ?? 0;
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (orderId.value > 0) {
      unawaited(_loadData());
    } else {
      Get.snackbar('register_error_title'.tr, 'order_error_invalid_id'.tr);
      unawaited(Get.offNamed<void>(AppRoutes.orders));
    }
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchOrder(),
        _fetchWallets(),
      ]);
      _autoSelectWallet();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchOrder() async {
    final orderService = Get.find<OrderService>();
    final fetchedOrder = await orderService.getOrder(orderId.value);
    if (fetchedOrder != null) {
      order.value = fetchedOrder;
    }
  }

  Future<void> _fetchWallets() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.wallets);
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        Wallet.listFromDynamic,
      );

      if (apiResponse.isSuccess) {
        wallets.assignAll(apiResponse.data);
      }
    } on Exception {
      // Ignored
    }
  }

  void _autoSelectWallet() {
    if (order.value == null || wallets.isEmpty) return;

    // Try to find a wallet with sufficient balance
    final orderTotal = order.value!.totalAmount;
    for (final wallet in wallets) {
      if (wallet.balance >= orderTotal) {
        selectedWallet.value = wallet;
        return;
      }
    }

    // Default to first if none have sufficient
    if (wallets.isNotEmpty) {
      selectedWallet.value = wallets.first;
    }
  }

  void updateSelectedWallet(Wallet wallet) {
    if (selectedWallet.value == wallet) return;
    selectedWallet.value = wallet;
  }

  bool get canPay {
    if (order.value == null || selectedWallet.value == null) return false;
    return selectedWallet.value!.balance >= order.value!.totalAmount;
  }

  Future<void> payOrder() async {
    if (!canPay) return;
    if (isPaying.value) return;

    isPaying.value = true;
    try {
      final orderService = Get.find<OrderService>();
      final success = await orderService.payWithWallet(
        orderId.value,
        selectedWallet.value!.id,
      );

      if (success) {
        Get.snackbar(
          'payment_successful'.tr,
          'order_payment_successful'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.surface,
          colorText: Get.theme.colorScheme.onSurface,
          borderRadius: 14,
          margin: const EdgeInsets.all(12),
        );
        await Get.offNamed<void>(AppRoutes.orders);
      } else {
        throw Exception('Payment failed');
      }
    } on DioException catch (error) {
      Get.snackbar(
        'payment_failed'.tr,
        parseApiErrorMessage(
          error,
          fallback: 'unable_process_payment'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('payment_failed'.tr, 'unable_process_payment'.tr);
    } finally {
      isPaying.value = false;
    }
  }

  void cancelPayment() {
    unawaited(Get.offNamed<void>(AppRoutes.orders));
  }
}
