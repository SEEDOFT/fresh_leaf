import 'package:dio/dio.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class ProfilePaymentController extends GetxController {
  final RxList<PaymentMethod> methods = <PaymentMethod>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString processingId = ''.obs;

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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openAddPaymentMethod() async {
    await _openPaymentEditor();
  }

  Future<void> openEditPaymentMethod(PaymentMethod method) async {
    await _openPaymentEditor(seed: method);
  }

  Future<void> setDefault(PaymentMethod method) async {
    if (processingId.value.isNotEmpty || method.isDefault == true) return;
    processingId.value = method.id.toString();
    try {
      methods.assignAll(
        methods.map(
          (item) => item.copyWith(isDefault: item.id == method.id),
        ),
      );
      Get.snackbar('updated'.tr, 'default_payment_updated'.tr);
    } finally {
      processingId.value = '';
    }
  }

  Future<void> remove(PaymentMethod method) async {
    if (processingId.value.isNotEmpty) return;
    processingId.value = method.id.toString();
    try {
      methods.removeWhere((item) => item.id == method.id);
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

  Future<void> _openPaymentEditor({PaymentMethod? seed}) async {
    final hasDefaultMethod =
        methods.isNotEmpty && methods.first.isDefault == true;
    final routeResult = await Get.toNamed<dynamic>(
      AppRoutes.paymentMethodsAdd,
      arguments: <String, dynamic>{
        'seed': seed,
        'has_default_method': hasDefaultMethod,
      },
    );
    final result = _toPaymentMethod(routeResult);
    if (result == null) return;

    final isEdit = seed != null;
    final firstItem = methods.isEmpty;
    final shouldBeDefault =
        firstItem || (!hasDefaultMethod && result.isDefault == true);
    final normalized = result.copyWith(isDefault: shouldBeDefault);

    if (shouldBeDefault) {
      methods.assignAll(
        methods.map((item) => item.copyWith(isDefault: false)),
      );
    }

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
    Get.snackbar('success'.tr, 'payment_method_added'.tr);
  }
}
