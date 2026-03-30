import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProfileSecurityController extends GetxController {
  final verifyPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isVerifyPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isPasswordVerified = false.obs;

  String _verifiedPassword = '';

  Future<void> verifyPasswordFirst() async {
    if (isLoading.value) return;
    final password = verifyPasswordController.text.trim();
    if (password.isEmpty) {
      Get.snackbar('Missing password', 'Please enter your current password.');
      return;
    }

    isLoading.value = true;
    try {
      final api = Get.find<ApiClient>();
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
        return;
      }

      _verifiedPassword = password;
      isPasswordVerified.value = true;
      Get.snackbar('Verified', 'Password verified successfully.');
    } on DioException catch (e) {
      Get.snackbar(
        'Verification failed',
        _extractApiMessage(e, fallback: 'Password verification failed'),
      );
    } catch (_) {
      Get.snackbar('Verification failed', 'Password verification failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword() async {
    if (isLoading.value) return;
    if (!isPasswordVerified.value) {
      Get.snackbar('Verification required', 'Please verify password first.');
      return;
    }

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Missing fields', 'Please enter new password and confirm it.');
      return;
    }
    if (newPassword.length < 6) {
      Get.snackbar('Weak password', 'Password must be at least 6 characters.');
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar('Mismatch', 'New password and confirmation must match.');
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
      Get.snackbar('Success', 'Password updated successfully.');
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
    final api = Get.find<ApiClient>();

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
        final response = await api.postRequest(
          ApiEndpoints.updatePassword,
          data: payload,
        );
        final apiResponse = ApiResponse.fromResponse<dynamic>(
          response.data,
          (json) => json,
        );
        if (apiResponse.isSuccess || response.statusCode == 200) {
          return true;
        }
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 422 || statusCode == 400) {
          // Try next payload shape.
          continue;
        }
        Get.snackbar(
          'Update failed',
          _extractApiMessage(e, fallback: 'Unable to update password'),
        );
        return false;
      } catch (_) {
        Get.snackbar('Update failed', 'Unable to update password');
        return false;
      }
    }

    Get.snackbar('Update failed', 'Unable to update password');
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
    verifyPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
