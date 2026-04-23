import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/constants/payment_method_type_codes.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class ProfilePaymentController extends GetxController {
  ProfilePaymentController();

  final RxList<PaymentMethod> methods = <PaymentMethod>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString processingId = ''.obs;
  final RxString selectedMethodId = ''.obs;

  bool isPickerMode = false;
  bool returnOnSelect = true;
  Set<String> allowedTypeCodes = <String>{PaymentMethodTypeCodes.creditDebit};

  @override
  void onInit() {
    super.onInit();
    _bindArgs();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await fetchPaymentMethods(showError: false);
  }

  Future<void> refreshPaymentMethods() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      await fetchPaymentMethods();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> fetchPaymentMethods({bool showError = true}) async {
    if (isLoading.value) return;
    isLoading.value = true;
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
      ).map(PaymentMethod.fromMap).where(_isAllowedType).toList();
      methods.assignAll(parsed);
      _ensureSelection();
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openAddPaymentMethod() async {
    await _openPaymentEditor();
  }

  Future<void> openEditPaymentMethod(PaymentMethod method) async {
    if (isPickerMode) return;
    await _openPaymentEditor(seed: method);
  }

  Future<void> remove(PaymentMethod method) async {
    if (isPickerMode) return;
    if (processingId.value.isNotEmpty) return;
    processingId.value = method.id.toString();
    try {
      methods.removeWhere((item) => item.id == method.id);
      _ensureSelection();
      Get.snackbar('deleted'.tr, 'payment_method_removed'.tr);
    } finally {
      processingId.value = '';
    }
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

  Future<void> selectForPick(PaymentMethod method) async {
    if (!isPickerMode) return;
    selectedMethodId.value = (method.id ?? 0).toString();
    if (returnOnSelect) {
      Get.back<PaymentMethod>(result: method);
    }
  }

  PaymentMethod? get selectedMethod {
    final current = selectedMethodId.value;
    if (current.isEmpty) return null;
    for (final method in methods) {
      if ((method.id ?? 0).toString() == current) return method;
    }
    return null;
  }

  void confirmPick() {
    if (!isPickerMode) return;
    final method = selectedMethod;
    if (method == null) {
      Get.snackbar('payment_method'.tr, 'select_payment_method_to_continue'.tr);
      return;
    }
    Get.back<PaymentMethod>(result: method);
  }

  Future<void> _openPaymentEditor({PaymentMethod? seed}) async {
    final routeResult = await Get.toNamed<dynamic>(
      AppRoutes.paymentMethodsAdd,
      arguments: <String, dynamic>{
        'seed': seed,
        'exclude_wallet_type': true,
        'preferred_payment_method_type_code':
            PaymentMethodTypeCodes.creditDebit,
        'allowed_payment_method_type_codes': <String>[
          PaymentMethodTypeCodes.creditDebit,
        ],
      },
    );
    final result = _toPaymentMethod(routeResult);
    if (result == null) return;

    final isEdit = seed != null;
    final normalized = result.copyWith(isDefault: false);

    if (isEdit) {
      final index = methods.indexWhere((item) => item.id == normalized.id);
      if (index >= 0) {
        methods[index] = normalized;
      } else {
        methods.insert(0, normalized);
      }
      Get.snackbar('success'.tr, 'payment_method_updated'.tr);
      return;
    }

    methods.insert(0, normalized);
    _ensureSelection();
    if (isPickerMode && returnOnSelect) {
      Get.back<PaymentMethod>(result: normalized);
      return;
    }
    Get.snackbar('success'.tr, 'payment_method_added'.tr);
  }

  void _bindArgs() {
    final args = Get.arguments;
    final map = _toMap(args);
    if (map == null) return;

    final mode = formatToString(map['mode']).trim().toLowerCase();
    isPickerMode = mode == 'pick';
    returnOnSelect = map['return_on_select'] != false;

    final allowed = _extractAllowedCodes(
      map['allowed_payment_method_type_codes'],
    );
    if (allowed.isNotEmpty) {
      allowedTypeCodes = allowed;
    }
  }

  Set<String> _extractAllowedCodes(dynamic raw) {
    if (raw is List) {
      return raw
          .map((item) => formatToString(item).trim().toLowerCase())
          .where((item) => item.isNotEmpty)
          .toSet();
    }
    return <String>{};
  }

  Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map<String, dynamic>(
        (key, dynamic item) => MapEntry<String, dynamic>(key.toString(), item),
      );
    }
    return null;
  }

  bool _isAllowedType(PaymentMethod method) {
    final code = (method.paymentMethodType?.code ?? '').trim().toLowerCase();
    if (code.isNotEmpty) {
      return allowedTypeCodes.contains(code);
    }
    return allowedTypeCodes.contains(PaymentMethodTypeCodes.creditDebit);
  }

  void _ensureSelection() {
    if (methods.isEmpty) {
      selectedMethodId.value = '';
      return;
    }
    final current = selectedMethodId.value;
    if (current.isEmpty) {
      selectedMethodId.value = (methods.first.id ?? 0).toString();
      return;
    }
    final exists = methods.any((m) => (m.id ?? 0).toString() == current);
    if (!exists) {
      selectedMethodId.value = (methods.first.id ?? 0).toString();
    }
  }
}
