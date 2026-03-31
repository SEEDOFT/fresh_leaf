import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileSettingsController extends GetxController {
  final AppSettingsController appSettings = Get.find<AppSettingsController>();
  final AiChatStorageService _chatStorage = Get.find<AiChatStorageService>();

  RxBool get notificationsEnabled => appSettings.notificationsEnabled;
  Rx<ThemeMode> get themeMode => appSettings.themeMode;
  Rx<Locale> get locale => appSettings.locale;

  Future<void> changeTheme(ThemeMode mode) async {
    await appSettings.setThemeMode(mode);
  }

  Future<void> changeLanguage(Locale value) async {
    await appSettings.setLocale(value);
  }

  Future<void> toggleNotification(bool enabled) async {
    await appSettings.setNotificationsEnabled(enabled);
  }

  Future<void> clearAiHistory() async {
    await _chatStorage.clearMessages();
    Get.snackbar('success'.tr, 'chat_history_cleared'.tr);
  }

  Future<void> openDeviceSettings() async {
    await openAppSettings();
  }
}
