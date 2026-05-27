import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_method.dart';
import 'package:fresh_leaf/core/models/user_address.dart';
import 'package:fresh_leaf/core/models/user_profile.dart';
import 'package:fresh_leaf/core/models/wallet.dart';
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

  final RxList<UserAddress> addresses = <UserAddress>[].obs;
  final RxList<Wallet> wallets = <Wallet>[].obs;
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    unawaited(refreshProfile());
    unawaited(preloadSubModules());
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

  Future<void> preloadSubModules() async {
    unawaited(_preloadAddresses());
    unawaited(_preloadWallets());
    unawaited(_preloadPaymentMethods());
  }

  Future<void> _preloadAddresses() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.addresses);
      final apiResponse = ApiResponse.parseDynamic(response.data);
      if (apiResponse.isSuccess || response.statusCode == 200) {
        final items = _extractAddressMaps(apiResponse.data)
            .map(UserAddress.fromMap)
            .toList();
        addresses.assignAll(items);
      }
    } on Exception {
      // Fail silently
    }
  }

  Future<void> _preloadWallets() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.userWallets);
      final apiResponse = ApiResponse.fromResponse(
        response.data,
        Wallet.listFromDynamic,
      );
      if (apiResponse.isSuccess || response.statusCode == 200) {
        wallets.assignAll(apiResponse.data);
      }
    } on Exception {
      // Fail silently
    }
  }

  Future<void> _preloadPaymentMethods() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.paymentMethods,
      );
      final apiResponse = ApiResponse.parseDynamic(response.data);
      if (apiResponse.isSuccess || response.statusCode == 200) {
        final parsed = _extractPaymentMaps(apiResponse.data)
            .map(PaymentMethod.fromMap)
            .toList();
        paymentMethods.assignAll(parsed);
      }
    } on Exception {
      // Fail silently
    }
  }

  List<Map<String, dynamic>> _extractAddressMaps(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map<String, dynamic>) {
      final nested = data['items'] ?? data['addresses'] ?? data['data'];
      if (nested is List) {
        return nested.whereType<Map<String, dynamic>>().toList();
      }
    }
    return const <Map<String, dynamic>>[];
  }

  List<Map<String, dynamic>> _extractPaymentMaps(dynamic data) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map<String, dynamic>) {
      final nested = data['items'] ?? data['methods'] ?? data['data'];
      if (nested is List) {
        return nested.whereType<Map<String, dynamic>>().toList();
      }
    }
    return const <Map<String, dynamic>>[];
  }
}
