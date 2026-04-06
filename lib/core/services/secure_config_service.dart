import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// Secure configuration service for sensitive environment variables.
/// Stores API keys, tokens, and other secrets in encrypted storage.
class SecureConfigService extends GetxService {
  SecureConfigService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _apiUrlKey = 'api_url';

  String? _apiUrl;

  String? get apiUrl => _apiUrl;

  /// Initialize the service by loading stored values from secure storage.
  /// Call this during app bootstrap.
  Future<void> init() async {
    _apiUrl = await _storage.read(key: _apiUrlKey);
  }

  /// Store API URL securely.
  /// Used during build time to store environment variables.
  Future<void> setApiUrl(String url) async {
    _apiUrl = url;
    await _storage.write(key: _apiUrlKey, value: url);
  }

  /// Clear all stored secrets (useful for logout/reset).
  Future<void> clear() async {
    _apiUrl = null;
    await _storage.delete(key: _apiUrlKey);
  }

  /// Check if configuration is populated.
  bool get isConfigured => _apiUrl != null && _apiUrl!.isNotEmpty;
}
