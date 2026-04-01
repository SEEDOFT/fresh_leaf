import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// Secure configuration service for sensitive environment variables.
/// Stores API keys, tokens, and other secrets in encrypted storage.
class SecureConfigService extends GetxService {
  SecureConfigService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _apiUrlKey = 'api_url';
  static const _geminiApiKeyKey = 'gemini_api_key';

  String? _apiUrl;
  String? _geminiApiKey;

  String? get apiUrl => _apiUrl;
  String? get geminiApiKey => _geminiApiKey;

  /// Initialize the service by loading stored values from secure storage.
  /// Call this during app bootstrap.
  Future<void> init() async {
    _apiUrl = await _storage.read(key: _apiUrlKey);
    _geminiApiKey = await _storage.read(key: _geminiApiKeyKey);
  }

  /// Store API URL securely.
  /// Used during build time to store environment variables.
  Future<void> setApiUrl(String url) async {
    _apiUrl = url;
    await _storage.write(key: _apiUrlKey, value: url);
  }

  /// Store Gemini API key securely.
  /// Used during build time to store environment variables.
  Future<void> setGeminiApiKey(String key) async {
    _geminiApiKey = key;
    await _storage.write(key: _geminiApiKeyKey, value: key);
  }

  /// Clear all stored secrets (useful for logout/reset).
  Future<void> clear() async {
    _apiUrl = null;
    _geminiApiKey = null;
    await _storage.delete(key: _apiUrlKey);
    await _storage.delete(key: _geminiApiKeyKey);
  }

  /// Check if configuration is populated.
  bool get isConfigured => _apiUrl != null && _apiUrl!.isNotEmpty;
}
