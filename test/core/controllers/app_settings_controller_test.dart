import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_settings_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<StorageService>()])
void main() {
  group('AppSettingsController', () {
    late MockStorageService mockStorage;

    setUp(() {
      mockStorage = MockStorageService();
      when(mockStorage.themeMode).thenReturn('system');
      when(mockStorage.languageCode).thenReturn('km');
      when(mockStorage.countryCode).thenReturn('KH');
      when(mockStorage.notificationsEnabled).thenReturn(true);
    });

    tearDown(() {
      Get.reset();
    });

    test('onInit loads settings from storage with defaults', () {
      final controller = AppSettingsController(storageService: mockStorage);
      controller.onInit();

      expect(controller.themeMode.value, ThemeMode.system);
      expect(controller.locale.value.languageCode, 'km');
      expect(controller.notificationsEnabled.value, isTrue);
    });

    test('onInit loads dark theme from storage', () {
      when(mockStorage.themeMode).thenReturn('dark');
      final controller = AppSettingsController(storageService: mockStorage);
      controller.onInit();

      expect(controller.themeMode.value, ThemeMode.dark);
    });

    test('onInit loads light theme from storage', () {
      when(mockStorage.themeMode).thenReturn('light');
      final controller = AppSettingsController(storageService: mockStorage);
      controller.onInit();

      expect(controller.themeMode.value, ThemeMode.light);
    });

    test('setThemeMode updates value and saves to storage', () async {
      final controller = AppSettingsController(storageService: mockStorage);
      controller.onInit();

      await controller.setThemeMode(ThemeMode.dark, syncToBackend: false);

      expect(controller.themeMode.value, ThemeMode.dark);
      verify(mockStorage.saveThemeMode('dark')).called(1);
    });

    test('setThemeMode maps system correctly', () async {
      final controller = AppSettingsController(storageService: mockStorage);
      controller.onInit();

      await controller.setThemeMode(ThemeMode.system, syncToBackend: false);

      verify(mockStorage.saveThemeMode('system')).called(1);
    });

    test('setLocale updates value and saves to storage', () async {
      final controller = AppSettingsController(storageService: mockStorage);
      controller.onInit();

      await controller.setLocale(
        const Locale('en', 'US'),
        syncToBackend: false,
      );

      expect(controller.locale.value.languageCode, 'en');
      expect(controller.locale.value.countryCode, 'US');
      verify(mockStorage.saveLocale('en', 'US')).called(1);
    });

    test(
      'setNotificationsEnabled updates value and saves to storage',
      () async {
        final controller = AppSettingsController(storageService: mockStorage);
        controller.onInit();

        await controller.setNotificationsEnabled(enabled: false);

        expect(controller.notificationsEnabled.value, isFalse);
        verify(mockStorage.saveNotificationsEnabled(enabled: false)).called(1);
      },
    );
  });
}
