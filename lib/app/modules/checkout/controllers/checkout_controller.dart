import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/constants/payment_method_type_codes.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/core/models/payment_method_type.dart';
import 'package:fresh_leaf/core/models/payment_session.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:fresh_leaf/core/models/user_address.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutPaymentOption {
  const CheckoutPaymentOption({
    required this.id,
    required this.label,
    required this.typeCode,
    this.method,
  });

  final String id;
  final String label;
  final String typeCode;
  final PaymentMethod? method;
}

class CheckoutController extends GetxController {
  final CartController cart = Get.find<CartController>();
  final TextEditingController noteController = TextEditingController();

  final RxList<PaymentMethodType> types = <PaymentMethodType>[].obs;
  final RxList<PaymentMethod> userCards = <PaymentMethod>[].obs;
  final Rxn<UserAddress> deliveryAddress = Rxn<UserAddress>();
  
  final RxBool isLoadingAddress = false.obs;
  final RxBool isLoadingPayments = false.obs;
  final RxString selectedOptionId = ''.obs;
  final RxBool isPlacingOrder = false.obs;

  static const String creditDebitOptionId =
      'channel-${PaymentMethodTypeCodes.creditDebit}';

  double get originalSubtotal {
    return cart.items.fold(0, (sum, item) => sum + ((item.vendorInventory?.price ?? 0) * item.quantity));
  }
  
  double get subtotal => originalSubtotal;
  double get discount => originalSubtotal - cart.subtotal;
  double get grandTotal => cart.subtotal;

  int get totalItems =>
      cart.items.fold<int>(0, (sum, item) => sum + item.quantity.toInt());

  List<CheckoutPaymentOption> get paymentOptions {
    final items = <CheckoutPaymentOption>[];

    for (final card in userCards) {
      final digits = card.cardNumber.replaceAll(RegExp('[^0-9]'), '');
      final last4 = digits.length >= 4
          ? digits.substring(digits.length - 4)
          : digits.padLeft(4, '*');
      final baseLabel = (card.label?.trim().isNotEmpty ?? false)
          ? card.label!.trim()
          : 'credit_debit_card'.tr;
      items.add(
        CheckoutPaymentOption(
          id: card.id?.toString() ?? 'card_${items.length}',
          label: '$baseLabel •••• $last4',
          typeCode: PaymentMethodTypeCodes.creditDebit,
          method: card,
        ),
      );
    }

    for (final type in types) {
      final code = (type.code ?? '').toLowerCase();
      if (code == PaymentMethodTypeCodes.creditDebit) {
        continue;
      }
      
      final exists = items.any((option) => option.typeCode == code);
      if (exists) continue;
      items.add(
        CheckoutPaymentOption(
          id: 'channel-$code',
          label: type.name ?? code,
          typeCode: code,
        ),
      );
    }

    final ccType = types.firstWhereOrNull((t) => t.code == PaymentMethodTypeCodes.creditDebit);
    if (ccType != null) {
      items.add(
        CheckoutPaymentOption(
          id: 'add_new_card',
          label: userCards.isEmpty ? (ccType.name ?? 'credit_debit_card'.tr) : 'add_new_card'.tr,
          typeCode: PaymentMethodTypeCodes.creditDebit,
        ),
      );
    }

    return items;
  }

  CheckoutPaymentOption? get selectedOption {
    final current = selectedOptionId.value;
    if (current.isEmpty) return null;
    for (final option in paymentOptions) {
      if (option.id == current) return option;
    }
    return null;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await Future.wait([
      fetchPaymentOptions(showError: false),
      fetchAddress(),
      fetchUserCards(),
    ]);
    _ensureSelection();
  }

  Future<void> fetchAddress() async {
    isLoadingAddress.value = true;
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.userAddresses);
      final apiResponse = ApiResponse.parseList(response.data);
      final parsed = apiResponse.data
          .map((e) => UserAddress.fromMap(e))
          .toList();
      if (parsed.isNotEmpty) {
        deliveryAddress.value = parsed.first;
      }
    } catch (_) {
      // Ignored
    } finally {
      isLoadingAddress.value = false;
    }
  }

  Future<void> changeDeliveryAddress() async {
    final routeResult = await Get.toNamed<dynamic>(
      AppRoutes.addresses,
      arguments: <String, dynamic>{
        'mode': 'pick',
        'return_on_select': true,
      },
    );
    if (routeResult is UserAddress) {
      deliveryAddress.value = routeResult;
    } else if (routeResult is Map<String, dynamic>) {
      deliveryAddress.value = UserAddress.fromMap(routeResult);
    }
  }

  Future<void> fetchUserCards() async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.userPaymentMethods);
      final apiResponse = ApiResponse.parseList(response.data);
      final parsed = apiResponse.data
          .map((e) => PaymentMethod.fromMap(e))
          .toList();
      userCards.assignAll(parsed.where((card) =>
          card.paymentMethodType?.code == PaymentMethodTypeCodes.creditDebit));
    } catch (_) {
      // Ignored
    }
  }

  Future<void> fetchPaymentOptions({bool showError = true}) async {
    if (isLoadingPayments.value) return;
    isLoadingPayments.value = true;
    try {
      await _fetchPaymentTypes(showError: showError);
      _ensureSelection();
    } finally {
      isLoadingPayments.value = false;
    }
  }

  Future<void> selectPaymentOption(String id) async {
    if (id == 'add_new_card') {
      await _pickCreditDebitMethod();
      return;
    }
    selectedOptionId.value = id;
  }

  Future<void> placeOrder() async {
    if (cart.items.isEmpty || isPlacingOrder.value) return;
    final option = selectedOption;
    if (option == null) {
      Get.snackbar('payment_method'.tr, 'choose_payment_each_time'.tr);
      return;
    }
    if (option.typeCode == PaymentMethodTypeCodes.creditDebit &&
        option.method == null) {
      Get.snackbar('payment_method'.tr, 'select_payment_method_to_continue'.tr);
      return;
    }

    isPlacingOrder.value = true;
    try {
      final sessionService = Get.find<PaymentSessionService>();
      final session = await sessionService.createCheckoutSession(
        amount: grandTotal,
        paymentMethodTypeCode: option.typeCode,
        paymentMethodId: option.typeCode == PaymentMethodTypeCodes.creditDebit
            ? option.method?.id
            : null,
        items: cart.items
            .map(
              (item) => <String, dynamic>{
                'title': item.vendorInventory?.displayTitle ?? '',
                'subtitle': item.vendorInventory?.displaySubtitle ?? '',
                'quantity': item.quantity,
                'price': item.vendorInventory?.price ?? 0.0,
              },
            )
            .toList(),
      );

      final isRedirectType =
          option.typeCode == PaymentMethodTypeCodes.aba ||
          option.typeCode == PaymentMethodTypeCodes.acleda;
      if (isRedirectType) {
        final paid = await _handleRedirectPayment(session);
        if (!paid) return;
      }

      await _finalizeOrder();
    } on DioException catch (error) {
      Get.snackbar(
        'save_failed'.tr,
        parseApiErrorMessage(
          error,
          fallback: 'unable_create_payment_session'.tr,
        ),
      );
    } on Exception {
      Get.snackbar('save_failed'.tr, 'unable_create_payment_session'.tr);
    } finally {
      isPlacingOrder.value = false;
    }
  }

  Future<bool> _handleRedirectPayment(PaymentSession session) async {
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

  Future<void> _fetchPaymentTypes({required bool showError}) async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(
        ApiEndpoints.userPaymentMethodTypes,
      );
      final apiResponse = ApiResponse.parseList(response.data);
      final parsed = apiResponse.data.map(PaymentMethodType.fromMap).toList();
      types.assignAll(parsed);
    } on DioException catch (error) {
      if (showError) {
        Get.snackbar(
          'fetch_failed'.tr,
          parseApiErrorMessage(
            error,
            fallback: 'unable_load_payment_method_types'.tr,
          ),
        );
      }
    } on Exception {
      if (showError) {
        Get.snackbar('fetch_failed'.tr, 'unable_load_payment_method_types'.tr);
      }
    }
  }

  void _ensureSelection() {
    final options = paymentOptions;
    if (options.isEmpty) {
      selectedOptionId.value = '';
      return;
    }
    final current = selectedOptionId.value;
    final exists = options.any((option) => option.id == current);
    if (current.isNotEmpty && exists) return;
  }



  Future<void> _pickCreditDebitMethod() async {
    final routeResult = await Get.toNamed<dynamic>(
      AppRoutes.paymentMethods,
      arguments: <String, dynamic>{
        'mode': 'pick',
        'allowed_payment_method_type_codes': <String>[
          PaymentMethodTypeCodes.creditDebit,
        ],
        'return_on_select': true,
      },
    );
    final method = _toPaymentMethod(routeResult);
    if (method == null) return;
    
    await fetchUserCards();
    selectedOptionId.value = method.id?.toString() ?? '';
  }

  PaymentMethod? _toPaymentMethod(dynamic value) {
    if (value is PaymentMethod) {
      return value;
    }
    if (value is Map<String, dynamic>) {
      return PaymentMethod.fromMap(value);
    }
    if (value is Map) {
      final mapped = value.map<String, dynamic>(
        (key, dynamic item) => MapEntry<String, dynamic>(key.toString(), item),
      );
      return PaymentMethod.fromMap(mapped);
    }
    return null;
  }

  Future<void> _finalizeOrder() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final itemCount = totalItems;
    cart.clearCart();
    noteController.clear();

    if (Get.isRegistered<DashboardController>()) {
      Get.back<void>();
      Get.find<DashboardController>().currentIndex = 3;
    } else {
      await Get.offNamed<void>(AppRoutes.orders);
    }

    Get.snackbar(
      'order_confirmed'.tr,
      (itemCount == 1 ? 'order_on_the_way_one' : 'order_on_the_way_other')
          .trParams({'count': '$itemCount'}),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.surface,
      colorText: Get.theme.colorScheme.onSurface,
      borderRadius: 14,
      margin: const EdgeInsets.all(12),
    );
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
