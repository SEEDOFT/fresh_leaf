import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class ProfileSecurityController extends GetxController {
  ProfileSecurityController({required ApiClient apiClient})
    : _apiClient = apiClient;
  final TextEditingController verifyPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiClient _apiClient;

  final RxBool isLoading = false.obs;
  final RxBool isVerifyPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isPasswordVerified = false.obs;

  String _verifiedPassword = '';

  Future<void> verifyPasswordFirst() async {
    if (isLoading.value) return;
    final password = verifyPasswordController.text.trim();
    if (password.isEmpty) {
      Get.snackbar('missing_password'.tr, 'enter_current_password'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.postRequest(
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
        return;
      }

      _verifiedPassword = password;
      isPasswordVerified.value = true;
      Get.snackbar('verified'.tr, 'password_verified_success'.tr);
    } on DioException catch (e) {
      Get.snackbar(
        'verification_failed'.tr,
        parseApiErrorMessage(
          e,
          fallback: 'password_verification_failed'.tr,
        ),
      );
    } on Exception {
      Get.snackbar(
        'verification_failed'.tr,
        'password_verification_failed'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword() async {
    if (isLoading.value) return;
    if (!isPasswordVerified.value) {
      Get.snackbar(
        'verification_required'.tr,
        'verify_password_first_message'.tr,
      );
      return;
    }

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('missing_fields'.tr, 'enter_new_password_confirm'.tr);
      return;
    }
    if (newPassword.length < 6) {
      Get.snackbar('weak_password'.tr, 'password_min_length'.tr);
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar('mismatch'.tr, 'password_confirmation_match'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final ok = await _updatePasswordApi(
        currentPassword: _verifiedPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      if (!ok) return;

      newPasswordController.clear();
      confirmPasswordController.clear();
      resetVerification(clearPasswordField: true);
      Get.snackbar('success'.tr, 'password_updated_success'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void resetVerification({bool clearPasswordField = false}) {
    isPasswordVerified.value = false;
    _verifiedPassword = '';
    newPasswordController.clear();
    confirmPasswordController.clear();
    if (clearPasswordField) {
      verifyPasswordController.clear();
    }
  }

  Future<bool> _updatePasswordApi({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final payloads = <Map<String, dynamic>>[
      {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
      {
        'password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
      {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    ];

    for (final payload in payloads) {
      try {
        final response = await _apiClient.postRequest(
          ApiEndpoints.updatePassword,
          data: payload,
        );
        final apiResponse = ApiResponse.parseDynamic(response.data);
        if (apiResponse.isSuccess || response.statusCode == 200) {
          return true;
        }
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 422 || statusCode == 400) {
          continue;
        }
        Get.snackbar(
          'update_failed'.tr,
          parseApiErrorMessage(
            e,
            fallback: 'unable_update_password'.tr,
          ),
        );
        return false;
      } on Exception {
        Get.snackbar('update_failed'.tr, 'unable_update_password'.tr);
        return false;
      }
    }

    Get.snackbar('update_failed'.tr, 'unable_update_password'.tr);
    return false;
  }

  @override
  void onClose() {
    verifyPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
