/// Centralized build-time configuration.
///
/// Values are injected via `--dart-define` / `--dart-define-from-file`.
/// Example:
/// flutter run --dart-define=API_URL=https://api.freshleaf.dev
/// flutter run --dart-define=GEMINI_API_KEY=your_key_here
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
