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

  final RxList<PaymentMethod> methods = <PaymentMethod>[].obs;
  final RxList<PaymentMethodType> types = <PaymentMethodType>[].obs;
  final RxBool isLoadingPayments = false.obs;
  final RxString selectedOptionId = ''.obs;
  final RxBool isPlacingOrder = false.obs;

  double get subtotal => cart.subtotal;
  double get deliveryFee => cart.deliveryFee;
  double get discount => subtotal >= 25 ? 2.00 : 0.0;
  double get grandTotal => subtotal + deliveryFee - discount;

  int get totalItems => cart.items.fold<int>(0, (sum, item) => sum + item.quantity);

  List<CheckoutPaymentOption> get paymentOptions {
    final items = <CheckoutPaymentOption>[
      ...methods.map(
        (method) => CheckoutPaymentOption(
          id: 'method-${method.id ?? 0}',
          label: _resolveMethodLabel(method),
          typeCode: _resolveTypeCode(method),
          method: method,
        ),
      ),
    ];

    for (final type in types) {
      final code = (type.code ?? '').toLowerCase();
      if (code != PaymentMethodTypeCodes.aba &&
          code != PaymentMethodTypeCodes.acleda) {
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
    await fetchPaymentOptions(showError: false);
  }

  Future<void> fetchPaymentOptions({bool showError = true}) async {
    if (isLoadingPayments.value) return;
    isLoadingPayments.value = true;
    try {
      await Future.wait<void>([
        _fetchPaymentMethods(showError: showError),
        _fetchPaymentTypes(showError: showError),
      ]);
      _ensureSelection();
    } finally {
      isLoadingPayments.value = false;
    }
  }

  void selectPaymentOption(String id) {
    selectedOptionId.value = id;
  }

  Future<void> placeOrder() async {
    if (cart.items.isEmpty || isPlacingOrder.value) return;
    final option = selectedOption;
    if (option == null) {
      Get.snackbar('payment_method'.tr, 'choose_payment_each_time'.tr);
      return;
    }

    isPlacingOrder.value = true;
    try {
      final sessionService = Get.find<PaymentSessionService>();
      final session = await sessionService.createCheckoutSession(
        amount: grandTotal,
        paymentMethodTypeCode: option.typeCode,
        paymentMethodId: option.method?.id,
        items: cart.items
            .map(
              (item) => <String, dynamic>{
                'title': item.title,
                'subtitle': item.subtitle,
                'quantity': item.quantity,
                'price': item.price,
              },
            )
            .toList(),
      );

      final isRedirectType = option.typeCode == PaymentMethodTypeCodes.aba ||
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
    } on Exception catch (_) {
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
    return paid == true;
  }

  Future<bool> _tryOpenRedirect(String? url) async {
    if ((url ?? '').isEmpty) return false;
    final uri = Uri.tryParse(url!);
    if (uri == null) return false;
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _fetchPaymentMethods({required bool showError}) async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.userPaymentMethods);
      final apiResponse = ApiResponse.parseDynamic(response.data);
      final parsed = _extractPaymentMaps(apiResponse.data).map(PaymentMethod.fromMap).toList();
      methods.assignAll(parsed);
    } on DioException catch (error) {
      if (showError) {
        Get.snackbar(
          'fetch_failed'.tr,
          parseApiErrorMessage(error, fallback: 'unable_load_payment_methods'.tr),
        );
      }
    } on Exception catch (_) {
      if (showError) {
        Get.snackbar('fetch_failed'.tr, 'unable_load_payment_methods'.tr);
      }
    }
  }

  Future<void> _fetchPaymentTypes({required bool showError}) async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(ApiEndpoints.userPaymentMethodTypes);
      final apiResponse = ApiResponse.parseList(response.data);
      final parsed = apiResponse.data.map(PaymentMethodType.fromMap).toList();
      types.assignAll(parsed.where((item) => (item.code ?? '').toLowerCase() != 'wallet'));
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
    } on Exception catch (_) {
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
    if (current.isEmpty || !options.any((option) => option.id == current)) {
      selectedOptionId.value = options.first.id;
    }
  }

  String _resolveMethodLabel(PaymentMethod method) {
    if ((method.label ?? '').isNotEmpty) return method.label!;
    if ((method.paymentMethodType?.name ?? '').isNotEmpty) {
      return method.paymentMethodType!.name!;
    }
    return 'payment_method'.tr;
  }

  String _resolveTypeCode(PaymentMethod method) {
    final code = (method.paymentMethodType?.code ?? '').trim().toLowerCase();
    if (code.isNotEmpty) return code;
    return PaymentMethodTypeCodes.creditDebit;
  }

  List<Map<String, dynamic>> _extractPaymentMaps(dynamic data) {
    if (data is List) return data.whereType<Map<String, dynamic>>().toList();
    if (data is Map<String, dynamic>) {
      final nested = data['items'] ?? data['methods'] ?? data['data'];
      if (nested is List) {
        return nested.whereType<Map<String, dynamic>>().toList();
      }
    }
    return const <Map<String, dynamic>>[];
  }

  Future<void> _finalizeOrder() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final itemCount = totalItems;
    cart.clearCart();

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
