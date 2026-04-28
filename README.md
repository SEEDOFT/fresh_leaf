# FreshLeaf Organics (B2C Mobile App)

**FreshLeaf Organics** is a Flutter + GetX B2C mobile application for consumers to browse and purchase organic vegetables. It is the consumer-facing portion of the **FreshLeaf Organics** marketplace, where users buy directly from verified vendors.

The app includes auth, catalog, cart/checkout, wallet top-up, orders, profile,
wishlist, and AI assistant chat.

## Toolchain Baseline

- Flutter: `3.32.2` (pinned in `.fvmrc`)
- Dart SDK: `^3.8.1` (from `pubspec.yaml`)
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
fvm use 3.32.2
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
fvm install && fvm use 3.32.2
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
fvm use 3.32.2
fvm flutter pub get
```

### Verify Android toolchain

```bash
cd android && ./gradlew tasks
```

## 2) Environment Configuration

Create local config from example:

```bash
cp .env.example .env.local
```

Required keys:

```env
API_URL=http://your-api-host/api/v1
REVERB_WS_SCHEME=ws
REVERB_WS_HOST=192.168.0.108
REVERB_WS_PORT=8080
REVERB_APP_KEY=your_reverb_app_key
REVERB_AUTH_ENDPOINT=/broadcasting/auth
```

## 3) Run the App

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
