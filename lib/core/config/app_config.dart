/// Centralized build-time configuration.
///
/// Values are injected via `--dart-define-from-file`.
/// Example:
/// flutter run --dart-define-from-file=.env.local
final class AppConfig {
  AppConfig._();

  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.freshleaf.dev/api/v1',
  );

  static const baseAssetUrl = String.fromEnvironment(
    'BASE_ASSET_URL',
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

  static const reverbAuthEndpoint = String.fromEnvironment(
    'REVERB_AUTH_ENDPOINT',
  );

  // Firebase Credentials
  static const firebaseAndroidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
  );

  static const firebaseIosApiKey = String.fromEnvironment(
    'FIREBASE_IOS_API_KEY',
  );

  static const firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
  );

  static const firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGE_SENDER_ID',
  );

  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );

  static const firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );
}
