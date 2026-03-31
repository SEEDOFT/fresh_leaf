import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';

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

      final normalizedPhone = _normalizePhoneForApi(phoneController.text);
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
        await _hydrateUserProfile(loginData: dataMap);
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar(
          'Error',
          'Login failed: ${apiResponse.status.message.isNotEmpty ? apiResponse.status.message : 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data['status']['message'] ?? 'Network error';

      Get.snackbar('Error', 'Login failed: $errorMsg');
    } finally {
      isLoading.value = false;
    }
  }

  String _normalizePhoneForApi(String rawValue) {
    var raw = rawValue.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (raw.isEmpty) return '';

    // Only Cambodia prefix is allowed.
    if (raw.startsWith('+') && !raw.startsWith('+855')) {
      return '';
    }

    if (raw.startsWith('+855')) {
      raw = raw.substring(4);
    } else if (raw.startsWith('855')) {
      raw = raw.substring(3);
    }

    raw = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.startsWith('0')) {
      raw = raw.substring(1);
    }

    if (raw.isEmpty) return '';
    return '+855$raw';
  }

  Future<void> _hydrateUserProfile({
    Map<String, dynamic>? loginData,
  }) async {
    final fallbackProfile = _extractProfileFromLoginPayload(loginData);

    try {
      final api = Get.find<ApiClient>();
      final response = await api.getRequest(ApiEndpoints.userProfile);
      final apiResponse = ApiResponse.fromResponse<Map<String, dynamic>>(
        response.data,
        (json) => (json is Map<String, dynamic>) ? json : <String, dynamic>{},
      );

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        if (fallbackProfile != null) {
          _applyProfile(fallbackProfile);
        }
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      _applyProfile(profile);
    } catch (_) {
      if (fallbackProfile != null) {
        _applyProfile(fallbackProfile);
      }
    }
  }

  UserProfile? _extractProfileFromLoginPayload(Map<String, dynamic>? loginData) {
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

  void _applyProfile(UserProfile profile) {
    final storage = Get.find<StorageService>();
    storage.setUserProfile(profile);

    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().setProfile(profile);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
