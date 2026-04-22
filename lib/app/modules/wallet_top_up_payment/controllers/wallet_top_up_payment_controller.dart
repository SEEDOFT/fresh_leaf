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

class WalletTopUpPaymentController extends GetxController {
  final RxList<PaymentMethod> methods = <PaymentMethod>[].obs;
  final RxList<PaymentMethodType> types = <PaymentMethodType>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString selectedMethodId = ''.obs;
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
    await fetchPaymentOptions(showError: false);
  }

  Future<void> refreshPaymentMethods() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      await fetchPaymentOptions();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> fetchPaymentOptions({bool showError = true}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future.wait<void>([
        _fetchPaymentMethods(showError: showError),
        _fetchPaymentTypes(showError: showError),
      ]);
      _ensureSelection();
    } finally {
      isLoading.value = false;
    }
  }

  List<PaymentMethod> get displayMethods {
    final items = <PaymentMethod>[...methods];
    for (final type in types) {
      final code = (type.code ?? '').toLowerCase();
      if (code != PaymentMethodTypeCodes.aba &&
          code != PaymentMethodTypeCodes.acleda) {
        continue;
      }
      final alreadyExists = items.any(
        (m) => (m.paymentMethodType?.code ?? '').toLowerCase() == code,
      );
      if (alreadyExists) continue;
      items.add(_channelMethodFromType(type));
    }
    return items;
  }

  void selectMethod(PaymentMethod method) {
    selectedMethodId.value = (method.id ?? 0).toString();
  }

  PaymentMethod? get selectedMethod {
    final id = selectedMethodId.value;
    if (id.isEmpty) return null;
    for (final method in displayMethods) {
      if ((method.id ?? 0).toString() == id) return method;
    }
    return null;
  }

  String get formattedAmount {
    if (currency.value.toUpperCase() == 'USD') {
      return '\$${amount.value.toStringAsFixed(2)}';
    }
    return '${amount.value.toInt()} ៛';
  }

  void confirmSelection() {
    final method = selectedMethod;
    if (method == null) {
      Get.snackbar('payment_method'.tr, 'select_payment_method_to_continue'.tr);
      return;
    }
    Get.back<PaymentMethod>(result: method);
  }

  Future<void> openAddPaymentMethod() async {
    final routeResult = await Get.toNamed<dynamic>(
      AppRoutes.paymentMethodsAdd,
      arguments: <String, dynamic>{
        'exclude_wallet_type': true,
      },
    );
    final method = _toPaymentMethod(routeResult);
    if (method == null) return;
    methods.insert(0, method);
    selectedMethodId.value = (method.id ?? 0).toString();
  }

  Future<void> _fetchPaymentMethods({required bool showError}) async {
    try {
      final apiClient = Get.find<ApiClient>();
      final response = await apiClient.getRequest(
        ApiEndpoints.userPaymentMethods,
      );
      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        if (showError) {
          Get.snackbar(
            'fetch_failed'.tr,
            apiResponse.status.message.isNotEmpty
                ? apiResponse.status.message
                : 'unable_load_payment_methods'.tr,
          );
        }
        return;
      }

      final parsed = _extractPaymentMaps(
        apiResponse.data,
      ).map(PaymentMethod.fromMap).toList();
      methods.assignAll(parsed);
    } on DioException catch (error) {
      if (showError) {
        Get.snackbar(
          'fetch_failed'.tr,
          parseApiErrorMessage(
            error,
            fallback: 'unable_load_payment_methods'.tr,
          ),
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
      types.assignAll(
        parsed.where((type) => (type.code ?? '').toLowerCase() != 'wallet').toList(),
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
    } on Exception catch (_) {
      if (showError) {
        Get.snackbar('fetch_failed'.tr, 'unable_load_payment_method_types'.tr);
      }
    }
  }

  void _ensureSelection() {
    final options = displayMethods;
    if (options.isEmpty) {
      selectedMethodId.value = '';
      return;
    }
    final current = selectedMethodId.value;
    if (current.isEmpty) {
      selectedMethodId.value = (options.first.id ?? 0).toString();
      return;
    }
    final exists = options.any((m) => (m.id ?? 0).toString() == current);
    if (!exists) {
      selectedMethodId.value = (options.first.id ?? 0).toString();
    }
  }

  PaymentMethod _channelMethodFromType(PaymentMethodType type) {
    final id = -1000 - (type.id ?? 0);
    return PaymentMethod(
      id: id,
      label: type.name,
      cardNumber: '',
      cvv: '',
      paymentMethodTypeId: type.id ?? 0,
      paymentMethodType: type,
      paymentMethodStatusId: null,
      paymentMethodStatus: null,
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

  List<Map<String, dynamic>> _extractPaymentMaps(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map<String, dynamic>) {
      final nested = data['items'] ?? data['methods'] ?? data['data'];
      if (nested is List) {
        return nested.whereType<Map<String, dynamic>>().toList();
      }
    }
    return const <Map<String, dynamic>>[];
  }

  PaymentMethod? _toPaymentMethod(dynamic value) {
    if (value is PaymentMethod) return value;
    if (value is Map<String, dynamic>) return PaymentMethod.fromMap(value);
    if (value is Map) {
      final mapped = value.map<String, dynamic>(
        (key, dynamic item) => MapEntry<String, dynamic>(key.toString(), item),
      );
      return PaymentMethod.fromMap(mapped);
    }
    return null;
  }
}

