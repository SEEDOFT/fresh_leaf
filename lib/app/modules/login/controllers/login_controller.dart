import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    isLoading.value = true;
    try {
      final apiClient = Get.find<ApiClient>();
      final storageService = Get.find<StorageService>();

      var phone = phoneController.text.trim();
      if (phone.startsWith('0')) {
        phone = phone.substring(1);
        phoneController.text = phone;
      }

      final response = await apiClient.postRequest(
        ApiEndpoints.login,
        data: {
          'phone_number': '+855$phone',
          'password': passwordController.text,
        },
      );

      final apiResponse = ApiResponse.fromResponse(
        response.data,
        (json) => json,
      );

      if (apiResponse.isSuccess ||
          response.statusCode == 200 ||
          apiResponse.status.code == '200') {
        final dataMap =
            (apiResponse.data as Map?)?.cast<String, dynamic>() ?? {};
        final token = dataMap['access_token'];
        await storageService.saveToken(token);
        apiClient.updateAuthToken(token);
        storageService.setUserProfile(UserProfile.fromMap(apiResponse.data));
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar(
          'Error',
          'Login failed: ${apiResponse.status.message.isNotEmpty ? apiResponse.status.message : 'Unknown error'}',
        );
      }
    } catch (e) {
      final errorMsg = e is DioException
          ? e.response?.data['status']['message'] ?? 'Network error'
          : e.toString();

      Get.snackbar('Error', 'Login failed: $errorMsg');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
