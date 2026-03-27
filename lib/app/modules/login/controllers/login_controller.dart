import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  // Observable for password visibility
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
      final newPhoneNumber = phoneController.text.trim();

      final response = await apiClient.postRequest(
        ApiEndpoints.login,
        data: {
          'phone_number': newPhoneNumber,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200 ||
          response.data['status']['code'] == 200 ||
          response.data['status']['success'] == true) {
        final token = response.data['access_token'];
        await storageService.saveToken(token);
        apiClient.updateAuthToken(token);
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar(
          'Error',
          'Login failed: ${response.data['status']['message']}',
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
