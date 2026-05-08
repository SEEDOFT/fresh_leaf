import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class AppSettingsController extends GetxController {
  AppSettingsController({required StorageService storageService})
    : _storageService = storageService;

  final StorageService _storageService;

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Locale> locale = const Locale('km', 'KH').obs;
  final RxBool notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final mode = _storageService.themeMode;
    switch (mode) {
      case 'light':
        themeMode.value = ThemeMode.light;
      case 'dark':
        themeMode.value = ThemeMode.dark;
      default:
        themeMode.value = ThemeMode.system;
    }

    final langCode = _storageService.languageCode;
    final countryCode = _storageService.countryCode;
    if (langCode != null && langCode.isNotEmpty) {
      locale.value = Locale(langCode, countryCode);
    }

    notificationsEnabled.value = _storageService.notificationsEnabled;
  }

  Future<void> setThemeMode(ThemeMode mode, {bool syncToBackend = true}) async {
    themeMode.value = mode;
    final themeStr = _mapThemeMode(mode);
    await _storageService.saveThemeMode(themeStr);
    Get.changeThemeMode(mode);
    if (syncToBackend) {
      await _syncPreferencesWithBackend(preferTheme: themeStr);
    }
  }

  Future<void> setLocale(Locale value, {bool syncToBackend = true}) async {
    locale.value = value;
    await _storageService.saveLocale(value.languageCode, value.countryCode);
    await Get.updateLocale(value);
    if (syncToBackend) {
      await _syncPreferencesWithBackend(localeCode: value.languageCode);
    }
  }

  Future<void> setNotificationsEnabled({required bool enabled}) async {
    notificationsEnabled.value = enabled;
    await _storageService.saveNotificationsEnabled(enabled: enabled);
  }

  Future<void> _syncPreferencesWithBackend({
    String? preferTheme,
    String? localeCode,
  }) async {
    final token = _storageService.token;
    if (token == null || token.isEmpty) return;

    try {
      final apiClient = Get.find<ApiClient>();
      await apiClient.patchRequest(
        ApiEndpoints.userUpdateProfile,
        data: {
          'prefer_theme': ?preferTheme,
          'locale': ?localeCode,
        },
      );
    } on Exception catch (e) {
      debugPrint('Failed to sync preferences with backend: $e');
    }
  }

  String _mapThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
