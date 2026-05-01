import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    isLoading.value = true;
    try {
      final apiClient = Get.find<ApiClient>();
      final storageService = Get.find<StorageService>();

      final normalizedPhone = normalizeCambodiaPhoneForApi(
        phoneController.text,
      );
      if (normalizedPhone.isEmpty) {
        Get.snackbar('Error', 'Please enter a valid phone number');
        return;
      }

      final response = await apiClient.postRequest(
        ApiEndpoints.login,
        data: {
          'phone_number': normalizedPhone,
          'password': passwordController.text,
        },
      );

      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess ||
          response.statusCode == 200 ||
          apiResponse.status.code == '200') {
        final dataMap = apiResponse.data;
        final token = _extractAccessToken(dataMap);
        if (token.isEmpty) {
          Get.snackbar('Error', 'Login succeeded but token was missing');
          return;
        }

        await storageService.saveToken(token);

        // Upload FCM token for notifications
        if (Get.isRegistered<NotificationService>()) {
          await Get.find<NotificationService>().uploadToken();
        }

        await _hydrateUserProfile(loginData: dataMap);
        await Get.offAllNamed<void>(AppRoutes.dashboard);
      } else {
        final errorMessage = apiResponse.status.message.isNotEmpty
            ? apiResponse.status.message
            : 'Unknown error';
        Get.snackbar(
          'Error',
          'Login failed: $errorMessage',
        );
      }
    } on DioException catch (e) {
      final message = parseApiErrorMessage(e);
      Get.snackbar(
        'Error',
        'Login failed: $message',
      );
    } on FormatException catch (e) {
      final message = parseApiErrorMessage(e);
      Get.snackbar('Error', 'Login failed: $message');
    } on Exception {
      Get.snackbar('Error', 'Login failed: Unexpected error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _hydrateUserProfile({
    Map<String, dynamic>? loginData,
  }) async {
    final storage = Get.find<StorageService>();
    final fallbackProfile = _extractProfileFromLoginPayload(loginData);

    try {
      final api = Get.find<ApiClient>();
      final response = await api.getRequest(
        ApiEndpoints.userProfile,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        if (fallbackProfile != null) {
          _applyProfile(fallbackProfile, storage);
        }
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      _applyProfile(profile, storage);
    } on DioException {
      if (fallbackProfile != null) {
        _applyProfile(fallbackProfile, storage);
      }
    }
  }

  UserProfile? _extractProfileFromLoginPayload(
    Map<String, dynamic>? loginData,
  ) {
    if (loginData == null || loginData.isEmpty) return null;

    final dynamic nestedUser = loginData['user'] ?? loginData['profile'];
    if (nestedUser is Map<String, dynamic>) {
      final profile = UserProfile.fromMap(nestedUser);
      if (_hasMeaningfulProfile(profile)) {
        return profile;
      }
    }

    final profile = UserProfile.fromMap(loginData);
    return _hasMeaningfulProfile(profile) ? profile : null;
  }

  bool _hasMeaningfulProfile(UserProfile profile) {
    return profile.firstName.trim().isNotEmpty ||
        profile.lastName.trim().isNotEmpty ||
        profile.email.trim().isNotEmpty ||
        profile.phoneNumber.trim().isNotEmpty;
  }

  void _applyProfile(UserProfile profile, StorageService storage) {
    storage.userProfile = profile;
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().setProfile(profile);
    }
  }

  String _extractAccessToken(Map<String, dynamic> dataMap) {
    final direct = formatToString(dataMap['access_token']);
    if (direct.isNotEmpty) return direct;

    final nested = dataMap['data'];
    if (nested is Map<String, dynamic>) {
      final nestedToken = formatToString(nested['access_token']);
      if (nestedToken.isNotEmpty) return nestedToken;
    }

    final token = dataMap['token'];
    if (token is String && token.isNotEmpty) {
      return token;
    }

    return '';
  }
}
