import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class PinVerificationController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final RxString pin = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  void onKeyPressed(String key) {
    if (isLoading.value) return;
    if (pin.value.length < 6) {
      pin.value += key;
      hasError.value = false;
      if (pin.value.length == 6) {
        unawaited(verifyPin());
      }
    }
  }

  void onDeletePressed() {
    if (isLoading.value) return;
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
      hasError.value = false;
    }
  }

  Future<void> verifyPin() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.verifyPin,
        data: {'pin': pin.value},
      );
      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (apiResponse.isSuccess || response.statusCode == 200) {
        await _completeVerification();
        return;
      }

      _setError('incorrect_pin'.tr);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = parseApiErrorMessage(
        e,
        fallback: 'unable_verify_pin'.tr,
      );

      if (statusCode == 422 && message.toLowerCase().contains('not set')) {
        Get
          ..back(result: false)
          ..snackbar(
            'pin_not_set'.tr,
            'setup_pin_instruction'.tr,
          );
        return;
      }

      _setError(message);
    } on Exception {
      _setError('unable_verify_pin'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void _setError(String message) {
    hasError.value = true;
    pin.value = '';
    Get.snackbar('invalid_pin'.tr, message);
  }

  Future<void> _completeVerification() async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    Get.back<bool>(result: true);
  }
}
