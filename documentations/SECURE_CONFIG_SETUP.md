# Secure Configuration Setup Guide

This guide explains how to use the secure configuration system for Fresh Leaf App to safely store and manage sensitive environment variables.

## Overview

The app uses **flutter_secure_storage** to encrypt and store sensitive data like API keys. This ensures:
- API keys are NOT embedded in the APK/AAB binary
- Data is NOT visible in logcat or debuggers
- Secrets are encrypted on-device using platform-specific key management

## Setup Steps

### 1. Create Your Environment Configuration Files

Copy the example file and create environment-specific files:

```bash
# For development
cp .env.example .env.local

# For production/client distribution
cp .env.example .env.prod
```

### 2. Fill in Your Secrets

Edit `.env.local` and `.env.prod` with your actual values:

```env
API_URL=https://your-api-server.com
REVERB_WS_SCHEME=wss
REVERB_WS_HOST=reverb.your-domain.com
REVERB_WS_PORT=443
REVERB_APP_KEY=your_reverb_app_key
```

⚠️ **IMPORTANT**: These `.env` files are already in `.gitignore`. Never commit them!

### 3. Build the App

#### Windows (PowerShell)

```powershell
# Development build
.\lib\scripts\build.ps1 -Env local -BuildType apk

# Production build for client
.\lib\scripts\build.ps1 -Env prod -BuildType appbundle

# Or use defaults (prod, appbundle)
.\lib\scripts\build.ps1
```

#### macOS/Linux

```bash
# Development build
./lib/scripts/build.sh local apk

# Production build for client
./lib/scripts/build.sh prod appbundle

# Or use defaults (prod, appbundle)
./lib/scripts/build.sh
```

### 4. Access Secrets in Your Code

The secrets are automatically loaded on app startup. Access them anywhere in your app:

```dart
import 'package:fresh_leaf/core/services/secure_config_service.dart';
import 'package:get/get.dart';

// Access the service
final secureConfig = Get.find<SecureConfigService>();

// Use the values
final apiUrl = secureConfig.apiUrl;

// Check if configured
if (secureConfig.isConfigured) {
  // Safe to use
}
```

## Security Features

### On Build Time
- ✅ Environment variables are passed via `--dart-define` flutter flags
- ✅ NOT hardcoded in the source code
- ✅ NOT visible in git history

### At Runtime
- ✅ Values are stored in encrypted Android Keystore (Android 23+)
- ✅ Values are stored in Keychain (iOS)
- ✅ NOT visible in logcat
- ✅ NOT visible in device debugger
- ✅ NOT readable by reverse engineering tools

### Obfuscation
- ✅ All class/method/field names are obfuscated (see `android/app/proguard-rules.pro`)
- ✅ All debug information is removed
- ✅ All logging is stripped from release builds
- ✅ Code cannot be decompiled to readable form

## Adding New Secrets

To add a new secret (e.g., `NEW_SECRET`):

### 1. Update `.env.example`
```env
NEW_SECRET=example_value_here
```

### 2. Update `SecureConfigService`
```dart
class SecureConfigService extends GetxService {
  static const _newSecretKey = 'new_secret';
  String? _newSecret;
  
  String? get newSecret => _newSecret;
  
  Future<void> setNewSecret(String value) async {
    _newSecret = value;
    await _storage.write(key: _newSecretKey, value: value);
  }
}
```

### 3. Use in your code
```dart
final secretValue = secureConfig.newSecret;
```

## Distribution to Clients

1. Create the production build:
   ```powershell
   .\lib\scripts\build.ps1 -Env prod -BuildType appbundle
   ```

2. The app bundle will be at: `build/app/outputs/bundle/release/app-release.aab`

3. Upload to Google Play Console

4. Users download and install the app - their secrets are stored securely on their device

## Troubleshooting

### Build fails with "Missing environment variables"
- Ensure your `.env.prod` file exists and has all required variables
- Check that there are no syntax errors in the .env file

### Secrets not loading at runtime
- Check that `SecureConfigService.init()` is called in `app_bootstrap.dart`
- Verify the app has not been uninstalled/reinstalled (clears encrypted storage)

### Cannot read secrets after reinstall
- This is expected - encrypted storage is app-specific and cleared on uninstall
- User will need to set secrets again or they load from fresh app install

## Best Practices

1. **Never** hardcode secrets in source code
2. **Never** log secrets or sensitive data
3. **Always** use `.env.local` for development
4. **Always** use `.env.prod` before building for client distribution
5. Keep `.env` files out of version control (already configured in `.gitignore`)
6. Consider using a key management service (e.g., AWS Secrets Manager, Azure Key Vault) for team environments
7. Rotate secrets periodically

## See Also

- [SecureConfigService documentation](../lib/core/services/secure_config_service.dart)
- [flutter_secure_storage package](https://pub.dev/packages/flutter_secure_storage)
- [ProGuard Rules documentation](../android/app/proguard-rules.pro)
- [AppConfig (compile-time config)](../lib/core/config/app_config.dart)
- [BUILD_FOR_CLIENT.md](BUILD_FOR_CLIENT.md) - Quick start guide
