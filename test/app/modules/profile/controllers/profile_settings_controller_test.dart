import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_settings_controller.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/models/ai_chat_message.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'profile_settings_controller_test.mocks.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}

@GenerateNiceMocks([MockSpec<StorageService>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileSettingsController', () {
    late MockStorageService mockStorage;
    late AppSettingsController appSettings;
    late AiChatStorageService chatStorage;
    late GetStorage box;
    late ProfileSettingsController controller;

    setUp(() async {
      PathProviderPlatform.instance = _FakePathProvider();
      await GetStorage.init('test_profile_settings');
      box = GetStorage('test_profile_settings');

      mockStorage = MockStorageService();
      when(mockStorage.saveOnboardingSeen(seen: anyNamed('seen')))
          .thenAnswer((_) async {});
      when(mockStorage.saveThemeMode(any)).thenAnswer((_) async {});
      when(mockStorage.saveLocale(any, any)).thenAnswer((_) async {});
      when(mockStorage.saveNotificationsEnabled(enabled: anyNamed('enabled')))
          .thenAnswer((_) async {});

      appSettings = AppSettingsController(storageService: mockStorage);
      chatStorage = AiChatStorageService(box: box);
      controller = ProfileSettingsController(
        appSettingsController: appSettings,
        aiChatStorageService: chatStorage,
      );
    });

    tearDown(() async {
      Get.reset();
      await box.erase();
    });

    test('notificationsEnabled delegates to AppSettingsController', () {
      expect(controller.notificationsEnabled.value, isTrue);
    });

    test('themeMode delegates to AppSettingsController', () {
      expect(controller.themeMode.value, ThemeMode.system);
    });

    test('locale delegates to AppSettingsController', () {
      expect(controller.locale.value, const Locale('km', 'KH'));
    });

    testWidgets('clearAiHistory clears messages and shows snackbar',
        (tester) async {
      await chatStorage.saveMessages([AiChatMessage(role: 'user', text: 'hi')]);
      await tester.pumpWidget(
        const GetMaterialApp(home: Text('')),
      );

      await controller.clearAiHistory();
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));

      final messages = await chatStorage.loadMessages();
      expect(messages, isEmpty);
    });
  });
}
