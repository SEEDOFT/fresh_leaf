import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final RxBool isLoading = false.obs;

  // State
  RxBool isPasswordVisible = false.obs;
  RxBool isPasswordConfirmVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void togglePasswordConfirmVisibility() {
    isPasswordConfirmVisible.value = !isPasswordConfirmVisible.value;
  }

  Future<void> nextPage() async {
    await Get.offNamed<void>(AppRoutes.login);
  }

  Future<void> signUp() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    final normalizedPhone = normalizeCambodiaPhoneForApi(
      phoneController.text,
    );
    if (normalizedPhone.isEmpty) {
      Get.snackbar('Error', 'Please enter a valid phone number');
      return;
    }

    if (passwordController.text != passwordConfirmController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    try {
      final apiClient = Get.find<ApiClient>();
      final storageService = Get.find<StorageService>();

      final response = await apiClient.postRequest(
        ApiEndpoints.register,
        data: {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'phone_number': normalizedPhone,
          'password': passwordController.text,
          'password_confirmation': passwordController.text,
        },
      );

      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess ||
          response.statusCode == 201 ||
          apiResponse.status.code == '201') {
        final dataMap = apiResponse.data;
        final token = formatToString(dataMap['access_token']);
        if (token.isEmpty) {
          Get.snackbar('Error', 'Registration succeeded but token missing');
          return;
        }
        await storageService.saveToken(token);

        // Upload FCM token for notifications
        if (Get.isRegistered<NotificationService>()) {
          await Get.find<NotificationService>().uploadToken();
        }

        await Get.offAllNamed<void>(AppRoutes.login);
      } else {
        Get.snackbar(
          'Error',
          'Registration failed: ${apiResponse.status.message}',
        );
      }
    } on DioException catch (e) {
      final message = parseApiErrorMessage(e);
      Get.snackbar(
        'Error',
        'Registration failed: $message',
      );
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
