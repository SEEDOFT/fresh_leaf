import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/models/wallet.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/pin_security_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class OrderWalletPaymentController extends GetxController {
  OrderWalletPaymentController({
    required OrderService orderService,
    required ApiClient apiClient,
  }) : _orderService = orderService,
       _apiClient = apiClient;

  final OrderService _orderService;
  final ApiClient _apiClient;
  final RxList<int> orderIds = <int>[].obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxList<Wallet> wallets = <Wallet>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isPaying = false.obs;

  final Rxn<Wallet> selectedWallet = Rxn<Wallet>();

  String? pin;

  bool isCheckout = false;
  Map<String, dynamic>? checkoutArgs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args['is_checkout'] == true) {
        isCheckout = true;
        checkoutArgs = args;
      } else {
        if (args['order_ids'] != null) {
          orderIds.assignAll(args['order_ids'] as List<int>);
        } else if (args['order_id'] != null) {
          orderIds.add(args['order_id'] as int);
        }
      }
      if (args['pin'] != null) {
        pin = args['pin'] as String;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (isCheckout || orderIds.isNotEmpty) {
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
        _fetchOrders(),
        _fetchWallets(),
      ]);
      _autoSelectWallet();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchOrders() async {
    final fetchedOrders = <Order>[];
    for (final id in orderIds) {
      final fetchedOrder = await _orderService.getOrder(id);
      if (fetchedOrder != null) {
        fetchedOrders.add(fetchedOrder);
      }
    }
    orders.assignAll(fetchedOrders);
  }

  double get totalAmount {
    final isKhr = selectedWallet.value != null && selectedWallet.value!.currency.code == 'KHR';
    
    if (isCheckout && checkoutArgs != null) {
      return isKhr 
          ? (checkoutArgs!['amount_khr'] as num).toDouble()
          : (checkoutArgs!['amount_usd'] as num).toDouble();
    }
    
    return orders.fold(0, (sum, order) => sum + (isKhr ? order.resolvedTotalAmountDisplay.khr : order.totalAmount));
  }

  MoneyDisplay get totalDisplay {
    if (isCheckout && checkoutArgs != null) {
      return MoneyDisplay(
        usd: (checkoutArgs!['amount_usd'] as num).toDouble(),
        khr: (checkoutArgs!['amount_khr'] as num).toDouble(),
      );
    }
    if (orders.isEmpty) return MoneyDisplay.empty;
    double usd = 0;
    double khr = 0;
    for (final order in orders) {
      usd += order.resolvedTotalAmountDisplay.usd;
      khr += order.resolvedTotalAmountDisplay.khr;
    }
    return MoneyDisplay(usd: usd, khr: khr);
  }

  Future<void> _fetchWallets() async {
    final token = Get.find<StorageService>().token;
    if (token == null || token.isEmpty) return;

    try {
      final response = await _apiClient.getRequest(ApiEndpoints.wallets);
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
    if (wallets.isNotEmpty) {
      selectedWallet.value = wallets.first;
    }
  }

  void updateSelectedWallet(Wallet wallet) {
    if (selectedWallet.value == wallet) return;
    selectedWallet.value = wallet;
  }

  bool get canPay {
    if ((!isCheckout && orders.isEmpty) || selectedWallet.value == null) return false;
    return selectedWallet.value!.balance >= totalAmount;
  }

  Future<void> payOrder() async {
    if (!canPay) {
      Get.snackbar('payment_failed'.tr, 'please_select_wallet'.tr);
      return;
    }
    if (isPaying.value) return;

    if (pin == null) {
      final storageService = Get.find<StorageService>();
      final hasPin = storageService.userProfile?.setPin ?? false;

      if (!hasPin) {
        final success = await Get.toNamed<dynamic>(
          AppRoutes.pinPasswordVerification,
          arguments: <String, dynamic>{'mode': 'set'},
        );
        if (success != true) {
          return; // User aborted PIN setup
        }

        if (storageService.userProfile != null) {
          storageService.userProfile = storageService.userProfile!.copyWith(
            setPin: true,
          );
        }
      }

      final pinResult = await PinSecurityService.verifyPin();
      if (pinResult == null) return;
      pin = pinResult;
    }

    isPaying.value = true;
    try {
      var success = false;
      if (isCheckout) {
        final cartService = Get.find<CartService>();
        final generatedOrderIds = await cartService.checkout(
          checkoutArgs!['address_id'] as int,
          checkoutArgs!['method_id'] as int?,
          checkoutArgs!['type_id'] as int,
          1,
          notes: checkoutArgs!['notes'] as String,
        );
        if (generatedOrderIds != null && generatedOrderIds.isNotEmpty) {
          isCheckout = false;
          orderIds.assignAll(generatedOrderIds);
          Get.find<CartController>()
              .clearCart(); // Clear 
              // local cart since backend cart is checked out

          success = await _orderService.batchPayWithWallet(
            orderIds,
            selectedWallet.value!.id,
            pin!,
          );
        }
      } else {
        success = await _orderService.batchPayWithWallet(
          orderIds,
          selectedWallet.value!.id,
          pin!,
        );
      }

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
    if (isCheckout) {
      Get.back<void>();
    } else {
      unawaited(Get.offNamed<void>(AppRoutes.orders));
    }
  }
}
