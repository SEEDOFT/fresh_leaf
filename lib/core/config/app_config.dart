/// Centralized build-time configuration.
///
/// Values are injected via `--dart-define-from-file`.
/// Example:
/// flutter run --dart-define-from-file=.env.local
final class AppConfig {
  AppConfig._();

  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.freshleaf.dev',
  );

  static const reverbWebSocketHost = String.fromEnvironment(
    'REVERB_WS_HOST',
  );

  static const reverbWebSocketPort = int.fromEnvironment(
    'REVERB_WS_PORT',
    defaultValue: 443,
  );

  static const reverbWebSocketScheme = String.fromEnvironment(
    'REVERB_WS_SCHEME',
    defaultValue: 'wss',
  );

  static const reverbAppKey = String.fromEnvironment(
    'REVERB_APP_KEY',
  );

  static const reverbAuthEndpointOverride = String.fromEnvironment(
    'REVERB_AUTH_ENDPOINT',
  );

  static String get reverbAuthEndpoint {
    if (reverbAuthEndpointOverride.isNotEmpty) {
      return reverbAuthEndpointOverride;
    }
    final normalizedApiUrl = apiUrl.replaceAll(RegExp(r'/+$'), '');
    const apiSuffix = '/api/v1';
    final baseOrigin = normalizedApiUrl.endsWith(apiSuffix)
        ? normalizedApiUrl.substring(
            0,
            normalizedApiUrl.length - apiSuffix.length,
          )
        : normalizedApiUrl;
    return '$baseOrigin/broadcasting/auth';
  }
}
