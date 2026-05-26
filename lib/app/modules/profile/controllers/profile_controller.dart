import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/pin_security_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;
  final RxString email = ''.obs;
  final RxString image = ''.obs;
  final RxString phone = ''.obs;
  final RxString memberSince = ''.obs;
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final profile = _storageService.userProfile;
    if (profile != null) {
      setProfile(profile);
    } else {
      final tokenPresent = _storageService.token?.isNotEmpty ?? false;
      if (tokenPresent) {
        userName.value = 'member_placeholder'.tr;
        email.value = '—';
        phone.value = '—';
        memberSince.value = 'active_member'.tr;
      }
    }
  }

  void setProfile(UserProfile profile) {
    userName.value = '${profile.lastName} ${profile.firstName}'.trim();
    email.value = profile.email;
    image.value = profile.image;
    phone.value = profile.phoneNumber;
    memberSince.value = profile.createdAt != null
        ? DateFormat(
            'dd MMM, yyyy',
          ).format(profile.createdAt!)
        : '';
  }

  Future<void> refreshProfile() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.profile,
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (!apiResponse.isSuccess && response.statusCode != 200) {
        Get.snackbar('update_failed'.tr, 'unable_refresh_profile'.tr);
        return;
      }

      final profile = UserProfile.fromMap(apiResponse.data);
      _storageService.userProfile = profile;
      setProfile(profile);

      // Sync preferences from backend to local app settings
      if (Get.isRegistered<AppSettingsController>()) {
        final settings = Get.find<AppSettingsController>();
        if (profile.locale.isNotEmpty) {
          await settings.setLocale(
            Locale(profile.locale),
            syncToBackend: false,
          );
        }
        final mode = switch (profile.theme) {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        };
        await settings.setThemeMode(mode, syncToBackend: false);
      }
    } on DioException catch (e) {
      Get.snackbar(
        'update_failed'.tr,
        e.message ?? 'unable_refresh_profile'.tr,
      );
    } on Exception {
      Get.snackbar('update_failed'.tr, 'unable_refresh_profile'.tr);
    }
  }

  Future<void> openOrders() async {
    final canOpen = await PinSecurityService.verifyOrderAccess();
    if (!canOpen) return;
    await Get.toNamed<void>(
      AppRoutes.orders,
      arguments: <String, dynamic>{
        'show_app_bar': true,
      },
    );
  }

  Future<void> logout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      if (Get.isRegistered<NotificationService>()) {
        await Get.find<NotificationService>().deleteToken();
      }

      await _apiClient.postRequest(ApiEndpoints.logout);
    } on DioException catch (e) {
      Get.snackbar('logout_failed'.tr, e.message ?? 'unable_logout'.tr);
    } on Exception {
      Get.snackbar('logout_failed'.tr, 'unable_logout'.tr);
    }

    await _storageService.clear();
    await Get.offAllNamed<void>(AppRoutes.login);
    isLoading.value = false;
  }
}
