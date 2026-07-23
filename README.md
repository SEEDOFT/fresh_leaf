# FreshLeaf Organics (B2C Mobile App)

**FreshLeaf Organics** is a Flutter + GetX B2C mobile application for consumers to browse and purchase organic vegetables. It is the consumer-facing portion of the **FreshLeaf Organics** marketplace, where users buy directly from verified vendors.

The app includes auth, catalog, cart/checkout, wallet top-up, orders, profile,
wishlist, and AI assistant chat.

## Toolchain Baseline

- Flutter: `stable` (pinned in `.fvmrc`)
- Dart SDK: `^3.9.0` (from `pubspec.yaml`)
- Java: `21` (pinned in `.mise.toml`)
- Gradle wrapper: `8.14`
- Android minSdk: `24` (required by `flutter_secure_storage 10.0.0`)

## 1) First-Time Setup

### Quick Command Packs (Install + Verify + Run)

Windows (PowerShell, mise):

```powershell
mise install
mise trust
dart pub global activate fvm
fvm install
fvm use stable
fvm flutter pub get
java -version
fvm flutter --version
cd android; .\gradlew tasks; cd ..
fvm flutter run --dart-define-from-file=.env.local
```

macOS/Linux:

```bash
mise install && mise trust
dart pub global activate fvm
fvm install && fvm use stable
fvm flutter pub get
java -version
fvm flutter --version
cd android && ./gradlew tasks && cd ..
fvm flutter run --dart-define-from-file=.env.local
```

### Java via mise (21)

```bash
mise install
mise trust
```

### Install Flutter via FVM and dependencies

```bash
dart pub global activate fvm
fvm install
fvm use stable
fvm flutter pub get
```

### Verify Android toolchain

```bash
cd android && ./gradlew tasks
```

## 2) Environment Configuration

Create local config from example:

```bash
# macOS/Linux
cp .env.example .env.local

# Windows (PowerShell)
copy .env.example .env.local
```

Required keys:

```env
# IMPORTANT: When testing on a physical device or emulator, 
# you MUST use your computer's local network IP address (e.g., 10.167.215.105).
# Do not use 'localhost' or '127.0.0.1'.
API_URL=http://<YOUR_LOCAL_IP>:8000/api/v1
BASE_ASSET_URL=http://<YOUR_LOCAL_IP>:8000

# Real-time WebSocket (Reverb) Configuration
REVERB_WS_SCHEME=ws
REVERB_WS_HOST=<YOUR_LOCAL_IP>
REVERB_WS_PORT=8080
REVERB_APP_KEY=d5523147baec470b2d6ea306a75d3b0dd8d1265b7808b0304d7f067d42d78977
REVERB_AUTH_ENDPOINT=/broadcasting/auth

# Firebase Configuration
# (Add the rest of your Firebase keys as defined in your .env.example)
```

> [!NOTE]
> Make sure `REVERB_WS_HOST` does **not** contain `http://`, `ws://`, or a port number (e.g., use `10.167.215.105` and specify the port `8080` separately in `REVERB_WS_PORT`).

## 3) Run the App

Before running the Flutter app, ensure the backend server is running and bound to the same local IP:
```bash
# In the FreshLeafApi directory
composer run dev -- --host=<YOUR_LOCAL_IP> --port=8000
```

Once the backend is up, start the Flutter app:
```bash
fvm flutter run --dart-define-from-file=.env.local
```

## 4) Build Scripts

Windows (PowerShell):

```powershell
.\lib\scripts\build.ps1 -Env local -BuildType apk
.\lib\scripts\build.ps1 -Env prod -BuildType appbundle
```

macOS/Linux:

```bash
./lib/scripts/build.sh local apk
./lib/scripts/build.sh prod appbundle
```

## 5) Project Structure

- `lib/app/modules/*`: feature modules (bindings/controllers/views/widgets)
- `lib/app/routes/*`: route names and page registration
- `lib/core/services/*`: API/storage/security/realtime services
- `lib/core/models/*`: shared data models
- `lib/core/localization/*`: EN/KM translations
- `documentations/*`: contributor and architecture docs

## 6) Common Commands

```bash
fvm flutter pub get
fvm flutter analyze
fvm flutter test
```

## 7) Additional Docs

- `documentations/PROJECT_GUIDELINE.md` - practical dev workflow guidelines
- `documentations/development_summary.md` - architecture and module details
- `documentations/SECURE_CONFIG_SETUP.md` - secure config setup
- `documentations/BUILD_FOR_CLIENT.md` - release build quick guide
- `documentations/VERY_GOOD_RULES.md` - lint and coding policy
