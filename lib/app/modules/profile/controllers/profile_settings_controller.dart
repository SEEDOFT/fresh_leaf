import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileSettingsController extends GetxController {
  ProfileSettingsController({
    required AppSettingsController appSettingsController,
    required AiChatStorageService aiChatStorageService,
  }) : _appSettings = appSettingsController,
       _chatStorage = aiChatStorageService;

  final AppSettingsController _appSettings;
  final AiChatStorageService _chatStorage;

  RxBool get notificationsEnabled => _appSettings.notificationsEnabled;
  Rx<ThemeMode> get themeMode => _appSettings.themeMode;
  Rx<Locale> get locale => _appSettings.locale;

  Future<void> changeTheme(ThemeMode mode) async {
    await _appSettings.setThemeMode(mode);
  }

  Future<void> changeLanguage(Locale value) async {
    await _appSettings.setLocale(value);
  }

  Future<void> toggleNotification({required bool enabled}) async {
    await _appSettings.setNotificationsEnabled(enabled: enabled);
  }

  Future<void> clearAiHistory() async {
    await _chatStorage.clearMessages();
    Get.snackbar('success'.tr, 'chat_history_cleared'.tr);
  }

  Future<void> openDeviceSettings() async {
    await openAppSettings();
  }
}
