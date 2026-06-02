import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/secure_config_service.dart';

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

void main() {
  group('SecureConfigService', () {
    late _FakeFlutterSecureStorage fakeStorage;
    late SecureConfigService service;

    setUp(() {
      fakeStorage = _FakeFlutterSecureStorage();
      service = SecureConfigService(storage: fakeStorage);
    });

    test('apiUrl is null before init', () {
      expect(service.apiUrl, isNull);
      expect(service.isConfigured, isFalse);
    });

    test('init loads apiUrl from storage', () async {
      await fakeStorage.write(key: 'api_url', value: 'https://example.com');
      await service.init();
      expect(service.apiUrl, 'https://example.com');
      expect(service.isConfigured, isTrue);
    });

    test('init handles missing api_url', () async {
      await service.init();
      expect(service.apiUrl, isNull);
      expect(service.isConfigured, isFalse);
    });

    test('setApiUrl stores value and updates property', () async {
      await service.setApiUrl('https://api.test.com');
      expect(service.apiUrl, 'https://api.test.com');
      expect(service.isConfigured, isTrue);

      final stored = await fakeStorage.read(key: 'api_url');
      expect(stored, 'https://api.test.com');
    });

    test('clear removes apiUrl from storage and nulls property', () async {
      await service.setApiUrl('https://api.test.com');
      expect(service.apiUrl, isNotNull);

      await service.clear();
      expect(service.apiUrl, isNull);
      expect(service.isConfigured, isFalse);

      final stored = await fakeStorage.read(key: 'api_url');
      expect(stored, isNull);
    });

    test('isConfigured returns false for empty string', () async {
      await service.setApiUrl('');
      expect(service.isConfigured, isFalse);
    });
  });
}
