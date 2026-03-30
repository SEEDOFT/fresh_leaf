import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProfilePinPasswordVerifyController extends GetxController {
  final passwordController = TextEditingController();
  final currentPinController = TextEditingController();
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isPasswordVerified = false.obs;
  final mode = 'set'.obs;
  String _verifiedPassword = '';

  bool get isResetMode => mode.value == 'reset';
  bool get isUpdateMode => mode.value == 'update';

  String get screenTitle {
    if (isResetMode) return 'Reset PIN';
    if (isUpdateMode) return 'Update PIN';
    return 'Set PIN';
  }

  String get actionTitle {
    if (isResetMode) return 'Reset PIN';
    if (isUpdateMode) return 'Update PIN';
    return 'Set PIN';
  }

  String get subtitle {
    if (isResetMode) {
      return 'Verify password first, then choose a new PIN.';
    }
    if (isUpdateMode) {
      return 'Verify password first, then provide current PIN to update.';
    }
    return 'Verify password before setting your PIN.';
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
      Get.snackbar('Verification required', 'Please verify password first.');
      return;
    }
    if (pin.isEmpty || confirmPin.isEmpty) {
      Get.snackbar('Missing fields', 'Please complete all fields.');
      return;
    }
    if (isUpdateMode && currentPin.isEmpty) {
      Get.snackbar('Missing fields', 'Please enter your current PIN.');
      return;
    }
    if (pin.length < 4) {
      Get.snackbar('Invalid PIN', 'PIN must be at least 4 digits.');
      return;
    }
    if (pin != confirmPin) {
      Get.snackbar('PIN mismatch', 'PIN and confirmation must match.');
      return;
    }

    isLoading.value = true;
    try {
      if (isResetMode) {
        final ok = await _resetPinWithPassword(
          _verifiedPassword,
          pin,
          confirmPin,
        );
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
      Get.snackbar('Missing password', 'Please enter your password.');
      return;
    }

    isLoading.value = true;
    try {
      final passwordOk = await _verifyPassword(password);
      if (!passwordOk) return;

      _verifiedPassword = password;
      isPasswordVerified.value = true;
      Get.snackbar('Verified', 'Password verified successfully.');
    } finally {
      isLoading.value = false;
    }
  }

  void resetVerification({bool clearPasswordField = false}) {
    isPasswordVerified.value = false;
    _verifiedPassword = '';
    currentPinController.clear();
    pinController.clear();
    confirmPinController.clear();
    if (clearPasswordField) {
      passwordController.clear();
    }
  }

  Future<bool> _verifyPassword(String password) async {
    final api = Get.find<ApiClient>();
    try {
      final response = await api.postRequest(
        ApiEndpoints.verifyPassword,
        data: {'password': password},
      );

      final apiResponse = ApiResponse.fromResponse<dynamic>(
        response.data,
        (json) => json,
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar(
          'Verification failed',
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'Password verification failed',
        );
        return false;
      }
      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'Verification failed',
        _extractApiMessage(e, fallback: 'Password verification failed'),
      );
      return false;
    } catch (_) {
      Get.snackbar('Verification failed', 'Password verification failed');
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

      final apiResponse = ApiResponse.fromResponse<dynamic>(
        response.data,
        (json) => json,
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar(
          'Set PIN failed',
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'Unable to set PIN',
        );
        return false;
      }
      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'Set PIN failed',
        _extractApiMessage(e, fallback: 'Unable to set PIN'),
      );
      return false;
    } catch (_) {
      Get.snackbar('Set PIN failed', 'Unable to set PIN');
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

      final apiResponse = ApiResponse.fromResponse<dynamic>(
        response.data,
        (json) => json,
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar(
          'Update PIN failed',
          apiResponse.status.message.isNotEmpty
              ? apiResponse.status.message
              : 'Unable to update PIN',
        );
        return false;
      }
      return true;
    } on DioException catch (e) {
      Get.snackbar(
        'Update PIN failed',
        _extractApiMessage(e, fallback: 'Unable to update PIN'),
      );
      return false;
    } catch (_) {
      Get.snackbar('Update PIN failed', 'Unable to update PIN');
      return false;
    }
  }

  Future<bool> _resetPinWithPassword(
    String password,
    String pin,
    String confirmPin,
  ) async {
    final api = Get.find<ApiClient>();

    final payloads = <Map<String, dynamic>>[
      {
        'password': password,
        'pin': pin,
        'pin_confirmation': confirmPin,
      },
      {
        'password': password,
        'current_pin': '',
        'pin': pin,
        'pin_confirmation': confirmPin,
      },
    ];

    for (final payload in payloads) {
      try {
        final response = await api.postRequest(
          ApiEndpoints.updatePin,
          data: payload,
        );
        final apiResponse = ApiResponse.fromResponse<dynamic>(
          response.data,
          (json) => json,
        );
        if (apiResponse.isSuccess || response.statusCode == 200) {
          return true;
        }
      } on DioException {
        // try next payload shape
      }
    }

    final setOk = await _setPin(pin, confirmPin);
    if (setOk) return true;

    Get.snackbar('Reset PIN failed', 'Unable to reset PIN');
    return false;
  }

  String _extractApiMessage(DioException error, {required String fallback}) {
    final responseData = error.response?.data;
    if (responseData is Map) {
      final status = responseData['status'];
      if (status is Map && status['message'] != null) {
        return status['message'].toString();
      }
    }
    return fallback;
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
