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
    defaultValue: 'ws',
  );

  static const reverbAppKey = String.fromEnvironment(
    'REVERB_APP_KEY',
  );

  static const reverbAuthEndpointPath = String.fromEnvironment(
    'REVERB_AUTH_ENDPOINT',
    defaultValue: '/broadcasting/auth',
  );

  static String get reverbAuthEndpoint {
    final normalizedApiUrl = apiUrl.replaceAll(RegExp(r'/+$'), '');
    final normalizedAuthPath = reverbAuthEndpointPath.startsWith('/')
        ? reverbAuthEndpointPath
        : '/$reverbAuthEndpointPath';
    return '$normalizedApiUrl$normalizedAuthPath';
  }
}
