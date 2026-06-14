import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController({
    required ApiClient apiClient,
    required StorageService storageService,
    required NotificationService notificationService,
    required ProfileController profileController,
    required AppSettingsController appSettings,
  }) : _apiClient = apiClient,
       _storageService = storageService,
       _notificationService = notificationService,
       _profileController = profileController,
       _appSettings = appSettings;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  final ApiClient _apiClient;
  final StorageService _storageService;
  final NotificationService _notificationService;
  final ProfileController _profileController;
  final AppSettingsController _appSettings;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final normalizedPhone = normalizeCambodiaPhoneForApi(
        phoneController.text,
      );
      if (normalizedPhone.isEmpty) {
        Get.snackbar('error'.tr, 'validation_invalid_phone'.tr);
        return;
      }

      final response = await _apiClient.postRequest(
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
          Get.snackbar('error'.tr, 'token_missing'.tr);
          return;
        }

        await _storageService.saveToken(token);

        await _notificationService.uploadToken();

        await _hydrateUserProfile(loginData: dataMap);
        await Get.offAllNamed<void>(AppRoutes.dashboard);
      } else {
        final errorMessage = apiResponse.status.message.isNotEmpty
            ? apiResponse.status.message
            : 'unknown_error'.tr;
        Get.snackbar(
          'error'.tr,
          'login_failed_message'.trParams({'message': errorMessage}),
        );
      }
    } on DioException catch (e) {
      final message = parseApiErrorMessage(e);
      Get.snackbar(
        'error'.tr,
        'login_failed_message'.trParams({'message': message}),
      );
    } on FormatException catch (e) {
      final message = parseApiErrorMessage(e);
      Get.snackbar(
        'error'.tr,
        'login_failed_message'.trParams({'message': message}),
      );
    } on Exception {
      Get.snackbar('error'.tr, 'unexpected_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _hydrateUserProfile({
    Map<String, dynamic>? loginData,
  }) async {
    final fallbackProfile = _extractProfileFromLoginPayload(loginData);

    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.profile,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        if (fallbackProfile != null) {
          _applyProfile(fallbackProfile, _storageService);
        }
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      _applyProfile(profile, _storageService);
    } on DioException {
      if (fallbackProfile != null) {
        _applyProfile(fallbackProfile, _storageService);
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
    _profileController.setProfile(profile);

    // Sync preferences from backend to local app settings
    if (profile.locale.isNotEmpty) {
      unawaited(
        _appSettings.setLocale(Locale(profile.locale), syncToBackend: false),
      );
    }

    final mode = switch (profile.theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    unawaited(_appSettings.setThemeMode(mode, syncToBackend: false));
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
