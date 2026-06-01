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
  RegisterController({
    required ApiClient apiClient,
    required StorageService storageService,
    required NotificationService notificationService,
  }) : _apiClient = apiClient,
       _storageService = storageService,
       _notificationService = notificationService;

  final ApiClient _apiClient;
  final StorageService _storageService;
  final NotificationService _notificationService;
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
      Get.snackbar('register_error_title'.tr, 'register_error_fill_fields'.tr);
      return;
    }

    final normalizedPhone = normalizeCambodiaPhoneForApi(
      phoneController.text,
    );
    if (normalizedPhone.isEmpty) {
      Get.snackbar(
        'register_error_title'.tr,
        'register_error_invalid_phone'.tr,
      );
      return;
    }

    if (passwordController.text != passwordConfirmController.text) {
      Get.snackbar(
        'register_error_title'.tr,
        'register_error_password_mismatch'.tr,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    try {
      final apiClient = _apiClient;
      final storageService = _storageService;

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
          Get.snackbar(
            'register_error_title'.tr,
            'register_error_token_missing'.tr,
          );
          return;
        }
        await storageService.saveToken(token);

        await _notificationService.uploadToken();

        await Get.offAllNamed<void>(AppRoutes.login);
      } else {
        Get.snackbar(
          'register_error_title'.tr,
          'register_error_failed'.trParams({
            'message': apiResponse.status.message,
          }),
        );
      }
    } on DioException catch (e) {
      final message = parseApiErrorMessage(e);
      Get.snackbar(
        'register_error_title'.tr,
        'register_error_failed'.trParams({'message': message}),
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
