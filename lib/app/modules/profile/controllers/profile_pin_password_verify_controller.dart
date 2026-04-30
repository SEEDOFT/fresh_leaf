import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class ProfilePinPasswordVerifyController extends GetxController {
  final passwordController = TextEditingController();
  final currentPinController = TextEditingController();
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isPasswordVerified = false.obs;
  final RxString mode = 'set'.obs;

  bool get isResetMode => mode.value == 'reset';
  bool get isUpdateMode => mode.value == 'update';

  String get screenTitle {
    if (isResetMode) return 'reset_pin'.tr;
    if (isUpdateMode) return 'update_pin'.tr;
    return 'set_pin'.tr;
  }

  String get actionTitle {
    if (isResetMode) return 'reset_pin'.tr;
    if (isUpdateMode) return 'update_pin'.tr;
    return 'set_pin'.tr;
  }

  String get subtitle {
    if (isResetMode) {
      return 'verify_then_choose_new_pin'.tr;
    }
    if (isUpdateMode) {
      return 'verify_then_provide_current_pin'.tr;
    }
    return 'verify_before_setting_pin'.tr;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['mode'] != null) {
      mode.value = args['mode'].toString();
    }
  }

  List<TextInputFormatter> get pinInputFormatter => <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(6),
  ];

  Future<void> submit() async {
    if (isLoading.value) return;

    final currentPin = currentPinController.text.trim();
    final pin = pinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    if (!isPasswordVerified.value) {
      Get.snackbar(
        'verification_required'.tr,
        'verify_password_first_message'.tr,
      );
      return;
    }
    if (pin.isEmpty || confirmPin.isEmpty) {
      Get.snackbar('missing_fields'.tr, 'complete_all_fields'.tr);
      return;
    }
    if (isUpdateMode && currentPin.isEmpty) {
      Get.snackbar('missing_fields'.tr, 'enter_current_pin_message'.tr);
      return;
    }
    if (pin.length < 4) {
      Get.snackbar('invalid_pin'.tr, 'pin_min_length'.tr);
      return;
    }
    if (pin != confirmPin) {
      Get.snackbar('pin_mismatch'.tr, 'pin_confirmation_match'.tr);
      return;
    }

    isLoading.value = true;
    try {
      if (isResetMode) {
        final ok = await _resetPin(pin, confirmPin);
        if (!ok) return;
      } else if (isUpdateMode) {
        final ok = await _updatePin(currentPin, pin, confirmPin);
        if (!ok) return;
      } else {
        final ok = await _setPin(pin, confirmPin);
        if (!ok) return;
      }

      Get.back(result: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyPasswordFirst() async {
    if (isLoading.value) return;
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      Get.snackbar('missing_password'.tr, 'enter_password'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final passwordOk = await _verifyPassword(password);
      if (!passwordOk) return;

      isPasswordVerified.value = true;
      Get.snackbar('verified'.tr, 'password_verified_success'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void resetVerification({bool clearPasswordField = false}) {
    isPasswordVerified.value = false;
    currentPinController.clear();
    pinController.clear();
    confirmPinController.clear();
    if (clearPasswordField) {
      passwordController.clear();
    }
  }

  Future<bool> _verifyPassword(String password) async {
    final apiClient = Get.find<ApiClient>();
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.verifyPassword,
        data: {'password': password},
      );

      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar(
          'verification_failed'.tr,
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'password_verification_failed'.tr,
        );
        return false;
      }
      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'verification_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'password_verification_failed'.tr,
        ),
      );
      return false;
    } on Exception {
      Get.snackbar(
        'verification_failed'.tr,
        'password_verification_failed'.tr,
      );
      return false;
    }
  }

  Future<bool> _setPin(String pin, String confirmPin) async {
    final api = Get.find<ApiClient>();
    try {
      final response = await api.postRequest(
        ApiEndpoints.setPin,
        data: {
          'pin': pin,
          'pin_confirmation': confirmPin,
        },
      );

      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar(
          'set_pin_failed'.tr,
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'unable_set_pin'.tr,
        );
        return false;
      }
      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'set_pin_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_set_pin'.tr,
        ),
      );
      return false;
    } on Exception {
      Get.snackbar('set_pin_failed'.tr, 'unable_set_pin'.tr);
      return false;
    }
  }

  Future<bool> _updatePin(
    String currentPin,
    String pin,
    String confirmPin,
  ) async {
    final api = Get.find<ApiClient>();
    try {
      final response = await api.postRequest(
        ApiEndpoints.updatePin,
        data: {
          'current_pin': currentPin,
          'pin': pin,
          'pin_confirmation': confirmPin,
        },
      );

      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar(
          'update_pin_failed'.tr,
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'unable_update_pin'.tr,
        );
        return false;
      }
      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'update_pin_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_update_pin'.tr,
        ),
      );
      return false;
    } on Exception {
      Get.snackbar('update_pin_failed'.tr, 'unable_update_pin'.tr);
      return false;
    }
  }

  Future<bool> _resetPin(
    String pin,
    String confirmPin,
  ) async {
    final apiClient = Get.find<ApiClient>();
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.resetPin,
        data: {
          'pin': pin,
          'pin_confirmation': confirmPin,
        },
      );
      final apiResponse = ApiResponse.parseDynamic(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar(
          'reset_pin_failed'.tr,
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'unable_update_pin'.tr,
        );
        return false;
      }

      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'reset_pin_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'unable_update_pin'.tr,
        ),
      );
      return false;
    } on Exception {
      Get.snackbar('reset_pin_failed'.tr, 'unable_update_pin'.tr);
      return false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    currentPinController.dispose();
    pinController.dispose();
    confirmPinController.dispose();
    super.onClose();
  }
}
