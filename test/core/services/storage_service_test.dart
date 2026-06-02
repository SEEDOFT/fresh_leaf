import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakeFlutterSecureStorage extends FlutterSecureStorage {
  final _store = <String, String>{};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.remove(key);
  }
}

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

void main() {
  group('StorageService', () {
    late _FakeFlutterSecureStorage fakeSecure;
    late GetStorage box;
    late StorageService service;

    setUp(() async {
      PathProviderPlatform.instance = _FakePathProvider();
      await GetStorage.init('test_storage_service');
      box = GetStorage('test_storage_service');
      fakeSecure = _FakeFlutterSecureStorage();
      service = StorageService(box: box, secureStorage: fakeSecure);
    });

    tearDown(() async {
      await box.erase();
    });

    group('init', () {
      test('loads defaults when nothing stored', () async {
        await service.init();
        expect(service.token, isNull);
        expect(service.onboardingSeen, isFalse);
        expect(service.securityPin, isNull);
        expect(service.pinOrderVerification, isFalse);
        expect(service.themeMode, 'system');
        expect(service.languageCode, 'km');
        expect(service.countryCode, 'KH');
        expect(service.notificationsEnabled, isTrue);
      });

      test('loads token from secure storage', () async {
        await fakeSecure.write(key: 'access_token', value: 'my_token');
        await service.init();
        expect(service.token, 'my_token');
      });

      test('migrates legacy token from GetStorage to secure storage', () async {
        await box.write('access_token', 'legacy_token');
        await service.init();
        expect(service.token, 'legacy_token');
        final secured = await fakeSecure.read(key: 'access_token');
        expect(secured, 'legacy_token');
        final legacy = box.read<String?>('access_token');
        expect(legacy, isNull);
      });

      test('loads stored non-default values', () async {
        await box.write('onboarding_seen', true);
        await box.write('security_pin', '1234');
        await box.write('pin_order_verification', true);
        await box.write('theme_mode', 'dark');
        await box.write('language_code', 'en');
        await box.write('country_code', 'US');
        await box.write('notifications_enabled', false);

        await service.init();

        expect(service.onboardingSeen, isTrue);
        expect(service.securityPin, '1234');
        expect(service.pinOrderVerification, isTrue);
        expect(service.themeMode, 'dark');
        expect(service.languageCode, 'en');
        expect(service.countryCode, 'US');
        expect(service.notificationsEnabled, isFalse);
      });
    });

    group('saveToken', () {
      test('saves token to secure storage', () async {
        await service.saveToken('new_token');
        expect(service.token, 'new_token');
        final stored = await fakeSecure.read(key: 'access_token');
        expect(stored, 'new_token');
      });

      test('clears token when null', () async {
        await fakeSecure.write(key: 'access_token', value: 'existing');
        await service.saveToken(null);
        expect(service.token, isNull);
        final stored = await fakeSecure.read(key: 'access_token');
        expect(stored, isNull);
      });
    });

    group('clear', () {
      test('resets all fields and removes stored values', () async {
        await fakeSecure.write(key: 'access_token', value: 'tok');
        await box.write('onboarding_seen', true);
        await box.write('security_pin', '1234');
        await box.write('pin_order_verification', true);

        await service.clear();

        expect(service.token, isNull);
        expect(service.onboardingSeen, isFalse);
        expect(service.userProfile, isNull);
        expect(service.securityPin, isNull);
        expect(service.pinOrderVerification, isFalse);

        expect(await fakeSecure.read(key: 'access_token'), isNull);
        expect(box.read<bool>('onboarding_seen'), isNull);
        expect(box.read<String?>('security_pin'), isNull);
        expect(box.read<bool>('pin_order_verification'), isNull);
      });
    });

    test('saveOnboardingSeen persists value', () async {
      await service.saveOnboardingSeen(seen: true);
      expect(service.onboardingSeen, isTrue);
      expect(box.read<bool>('onboarding_seen'), isTrue);
    });

    test('saveSecurityPin stores and clears correctly', () async {
      await service.saveSecurityPin('4321');
      expect(service.securityPin, '4321');
      expect(box.read<String?>('security_pin'), '4321');

      await service.saveSecurityPin(null);
      expect(service.securityPin, isNull);
      expect(box.read<String?>('security_pin'), isNull);
    });

    test('savePinOrderVerification persists value', () async {
      await service.savePinOrderVerification(enabled: true);
      expect(service.pinOrderVerification, isTrue);
      expect(box.read<bool>('pin_order_verification'), isTrue);

      await service.savePinOrderVerification(enabled: false);
      expect(service.pinOrderVerification, isFalse);
    });

    test('saveThemeMode persists value', () async {
      await service.saveThemeMode('dark');
      expect(service.themeMode, 'dark');
      expect(box.read<String>('theme_mode'), 'dark');
    });

    test('saveLocale persists language and country', () async {
      await service.saveLocale('en', 'US');
      expect(service.languageCode, 'en');
      expect(service.countryCode, 'US');
      expect(box.read<String>('language_code'), 'en');
      expect(box.read<String?>('country_code'), 'US');

      await service.saveLocale('km', null);
      expect(service.languageCode, 'km');
      expect(service.countryCode, isNull);
      expect(box.read<String?>('country_code'), isNull);
    });

    test('saveNotificationsEnabled persists value', () async {
      await service.saveNotificationsEnabled(enabled: false);
      expect(service.notificationsEnabled, isFalse);
      expect(box.read<bool>('notifications_enabled'), isFalse);
    });
  });
}
