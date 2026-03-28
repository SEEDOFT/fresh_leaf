/// Centralized build-time configuration.
///
/// Values are injected via `--dart-define-from-file`.
/// Example:
/// flutter run --dart-define-from-file=.env.local
class AppConfig {
  AppConfig._();

  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.freshleaf.dev',
  );

  static const geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
}
