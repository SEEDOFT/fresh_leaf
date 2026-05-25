import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/constants/payment_method_type_codes.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/core/models/payment_method_type.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class WalletTopUpChannelOption {
  const WalletTopUpChannelOption({
    required this.id,
    required this.label,
    required this.typeCode,
    this.type,
  });

  final String id;
  final String label;
  final String typeCode;
  final PaymentMethodType? type;

  bool get isCreditDebit => typeCode == PaymentMethodTypeCodes.creditDebit;
}

class WalletTopUpPaymentController extends GetxController {
  final RxList<PaymentMethodType> types = <PaymentMethodType>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString selectedChannelId = ''.obs;
  final RxString currency = 'USD'.obs;
  final RxDouble amount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      currency.value = formatToString(args['currency'], defaultValue: 'USD');
      amount.value = toDouble(args['amount']);
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await fetchPaymentTypes(showError: false);
  }

  Future<void> refreshPaymentMethods() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      await fetchPaymentTypes();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> fetchPaymentTypes({bool showError = true}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await _fetchPaymentTypes(showError: showError);
      _ensureSelection();
    } finally {
      isLoading.value = false;
    }
  }

  List<WalletTopUpChannelOption> get channelOptions {
    final items = <WalletTopUpChannelOption>[];
    final creditType = _findType(PaymentMethodTypeCodes.creditDebit);
    items.add(
      WalletTopUpChannelOption(
        id: 'channel-${PaymentMethodTypeCodes.creditDebit}',
        label: creditType?.name?.trim().isNotEmpty ?? false
            ? creditType!.name!.trim()
            : 'credit_debit_card'.tr,
        typeCode: PaymentMethodTypeCodes.creditDebit,
        type: creditType,
      ),
    );

    for (final type in types) {
      final code = (type.code ?? '').toLowerCase();
      if (code.isEmpty || code == PaymentMethodTypeCodes.creditDebit) {
        continue;
      }
      if (code != PaymentMethodTypeCodes.aba &&
          code != PaymentMethodTypeCodes.acleda) {
        continue;
      }
      final alreadyExists = items.any((option) => option.typeCode == code);
      if (alreadyExists) continue;
      items.add(
        WalletTopUpChannelOption(
          id: 'channel-$code',
          label: (type.name ?? code).trim(),
          typeCode: code,
          type: type,
        ),
      );
    }
    return items;
  }

  Future<void> selectChannel(WalletTopUpChannelOption option) async {
    if (option.isCreditDebit) {
      final selectedCard = await _openSavedCards();
      if (selectedCard != null) {
        Get.back<PaymentMethod>(result: selectedCard);
      }
      return;
    }
    selectedChannelId.value = option.id;
  }

  WalletTopUpChannelOption? get selectedChannel {
    final id = selectedChannelId.value;
    if (id.isEmpty) return null;
    for (final option in channelOptions) {
      if (option.id == id) return option;
    }
    return null;
  }

  String get formattedAmount {
    if (currency.value.toUpperCase() == 'USD') {
      return '\$${formatPrice(amount.value)}';
    }
    return '${amount.value.toInt()} ៛';
  }

  void confirmSelection() {
    final option = selectedChannel;
    if (option == null) {
      Get.snackbar('payment_method'.tr, 'select_payment_method_to_continue'.tr);
      return;
    }

    final method = _channelMethodFromOption(option);
    Get.back<PaymentMethod>(result: method);
  }

  Future<void> _fetchPaymentTypes({required bool showError}) async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(
        ApiEndpoints.userPaymentMethodTypes,
      );
      final apiResponse = ApiResponse.parseList(response.data);
      final parsed = apiResponse.data.map(PaymentMethodType.fromMap).toList();
      types.assignAll(
        parsed
            .where((type) => (type.code ?? '').toLowerCase() != 'wallet')
            .toList(),
      );
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
    final options = channelOptions
        .where((option) => !option.isCreditDebit)
        .toList();
    if (options.isEmpty) {
      selectedChannelId.value = '';
      return;
    }
    final current = selectedChannelId.value;
    if (current.isEmpty) {
      selectedChannelId.value = options.first.id;
      return;
    }
    final exists = options.any((option) => option.id == current);
    if (!exists) {
      selectedChannelId.value = options.first.id;
    }
  }

  PaymentMethod _channelMethodFromOption(WalletTopUpChannelOption option) {
    final type =
        option.type ??
        PaymentMethodType(
          code: option.typeCode,
          name: option.label,
        );
    final id = -1000 - (type.id ?? 0);
    return PaymentMethod(
      id: id,
      label: type.name,
      cardNumber: '',
      cvv: '',
      paymentMethodTypeId: type.id ?? 0,
      paymentMethodType: type,
      expiryMonth: 0,
      expiryYear: 0,
      cardHolderName: '',
      billingAddress: '',
      billingCity: '',
      billingState: '',
      billingZipCode: '',
      isDefault: false,
    );
  }

  PaymentMethodType? _findType(String code) {
    for (final type in types) {
      if ((type.code ?? '').toLowerCase() == code) return type;
    }
    return null;
  }

  Future<PaymentMethod?> _openSavedCards() async {
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
    if (routeResult is PaymentMethod) {
      return routeResult;
    }
    if (routeResult is Map<String, dynamic>) {
      return PaymentMethod.fromMap(routeResult);
    }
    if (routeResult is Map) {
      final mapped = routeResult.map<String, dynamic>(
        (key, dynamic item) => MapEntry<String, dynamic>(key.toString(), item),
      );
      return PaymentMethod.fromMap(mapped);
    }
    return null;
  }
}
