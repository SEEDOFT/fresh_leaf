import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class AppSettingsController extends GetxController {
  AppSettingsController({required StorageService storageService})
    : _storageService = storageService;

  final StorageService _storageService;

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Locale> locale = const Locale('en').obs;
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
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
        break;
    }

    final langCode = _storageService.languageCode;
    final countryCode = _storageService.countryCode;
    if (langCode != null && langCode.isNotEmpty) {
      locale.value = Locale(langCode, countryCode);
    }

    notificationsEnabled.value = _storageService.notificationsEnabled;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _storageService.saveThemeMode(_mapThemeMode(mode));
    Get.changeThemeMode(mode);
  }

  Future<void> setLocale(Locale value) async {
    locale.value = value;
    await _storageService.saveLocale(value.languageCode, value.countryCode);
    Get.updateLocale(value);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    notificationsEnabled.value = enabled;
    await _storageService.saveNotificationsEnabled(enabled);
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
