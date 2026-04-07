# Quick Start: Building for Client Distribution

## One-Time Setup

1. **Create production environment file:**
   ```powershell
   Copy-Item .env.example .env.prod
   ```

2. **Edit `.env.prod` with your production secrets:**
   ```env
   API_URL=https://your-production-api.com
   REVERB_WS_SCHEME=wss
   REVERB_WS_HOST=reverb.your-domain.com
   REVERB_WS_PORT=443
   REVERB_APP_KEY=your_reverb_app_key
   ```

## Build for Client

Run this command to build the release app bundle:

```powershell
.\lib\scripts\build.ps1 -Env prod -BuildType appbundle
```

### Build Options

- **App Bundle (recommended for Play Store):**
  ```powershell
  .\lib\scripts\build.ps1 -Env prod -BuildType appbundle
  ```
  Output: `build/app/outputs/bundle/release/app-release.aab`

- **APK (for direct installation):**
  ```powershell
  .\lib\scripts\build.ps1 -Env prod -BuildType apk
  ```
  Output: `build/app/outputs/apk/release/app-release.apk`

## Security Guarantees

✅ **Secrets are NOT in the binary** - They're loaded at runtime from encrypted storage
✅ **Cannot be reverse engineered** - Code is obfuscated and all debuggable symbols removed
✅ **Cannot be found in logcat** - All logging is stripped from release builds
✅ **Encrypted on device** - Uses Android Keystore encryption

## What Gets Built

Your app bundle includes:
- ✅ Fully obfuscated and minified code
- ✅ All debug information removed
- ✅ All logging statements stripped
- ✅ All unnecessary resources removed

The environment variables are:
- NOT in the APK/AAB file
- Loaded securely at runtime on the user's device
- Never logged or exposed to debuggers

## Distribution

1. The generated `.aab` or `.apk` is ready to distribute
2. Upload to Google Play Console
3. Users install and run - secrets load securely on their device
4. No additional configuration needed by end users

## Environment File Safety

- `.env.prod` is in `.gitignore` - will not be committed
- `.env.local` is in `.gitignore` - will not be committed  
- Only `.env.example` should be in version control

## Troubleshooting

If build fails:
1. Ensure `.env.prod` exists: `Test-Path .env.prod`
2. Check it has all required variables:
   `API_URL`, `REVERB_WS_SCHEME`, `REVERB_WS_HOST`,
   `REVERB_WS_PORT`, and `REVERB_APP_KEY`
3. Re-run the build command

Need help? See [SECURE_CONFIG_SETUP.md](SECURE_CONFIG_SETUP.md) for detailed documentation.
