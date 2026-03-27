import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';

class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final isLoading = false.obs;

  // State
  var isPasswordVisible = false.obs;
  var isPasswordConfirmVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void togglePasswordConfirmVisibility() {
    isPasswordConfirmVisible.value = !isPasswordConfirmVisible.value;
  }

  void nextPage() {
    Get.offNamed('/login');
  }

  void signUp() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    // Normalize phone: strip leading zero if present
    var phone = phoneController.text.trim();
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
      phoneController.text = phone;
    }
    if (phone.isEmpty) {
      Get.snackbar('Error', 'Please enter a valid phone number');
      return;
    }

    if (passwordController.text != passwordConfirmController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      final apiClient = Get.find<ApiClient>();
      final storageService = Get.find<StorageService>();

      final response = await apiClient.postRequest(
        ApiEndpoints.register,
        data: {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'phone_number': phone,
          'password': passwordController.text,
          'password_confirmation': passwordController.text,
        },
      );

      if (response.statusCode == 201 ||
          response.data['status']['code'] == '201' ||
          response.data['status']['success'] == true) {
        final token = response.data['token'];
        await storageService.saveToken(token);
        apiClient.updateAuthToken(token);
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar(
          'Error',
          'Registration failed: ${response.data['status']['message']}',
        );
      }
    } catch (e) {
      final errorMsg = e is DioException
          ? e.response?.data['status']['message'] ?? 'Network error'
          : e.toString();

      Get.snackbar('Error', 'Registration failed: $errorMsg');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }
}
