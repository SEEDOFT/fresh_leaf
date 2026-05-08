# FreshLeaf Project Guideline

This guide is the practical day-to-day handbook for contributors.

## 1) Prerequisites

- Java 21
- Flutter stable (via FVM)
- Dart SDK compatible with `^3.9.0`
- Android Gradle wrapper 8.14 (already pinned in repo)

## 2) Setup Flow

1. Install Java using mise.
2. Install and use Flutter with FVM.
3. Install pub dependencies.
4. Prepare `.env.local` from `.env.example`.
5. Run app with dart-define file.

Use the command packs in the root `README.md` for copy-paste setup.

## 3) Environment Keys

`AppConfig` reads from `--dart-define` keys:

- `API_URL`
- `REVERB_WS_SCHEME`
- `REVERB_WS_HOST`
- `REVERB_WS_PORT`
- `REVERB_APP_KEY`
- `REVERB_AUTH_ENDPOINT`

Local run example:

```bash
fvm flutter run --dart-define-from-file=.env.local
```

## 4) Architecture Rules

- Keep GetX module structure:
  - `bindings/`
  - `controllers/`
  - `views/`
  - `widgets/`
- Do not place large private widget classes inside view files.
- Reused controller logic belongs in shared helpers/services.
- Parse API envelopes through `ApiResponse` helpers, not raw map parsing
  inside controllers.

## 5) Current Payment Policy

- Saved payment methods are card-only (`credit_debit`).
- ABA/ACLEDA are pay-time channels in checkout/top-up flow, not addable
  saved methods.
- Top-up and checkout should keep channel-first behavior and explicit user
  selection each time.

## 6) AI Assistant Realtime Policy

- Subscribe to private channel first, then send message.
- Channel format:
  - `private-ai-chat.{userId}.{sessionId}`
- Message send uses REST endpoint `/ai/chat/messages`.
- Realtime UI updates are driven by events:
  - `AiMessageStarted`
  - `AiMessageChunk`
  - `AiMessageCompleted`
  - `AiMessageFailed`
- History endpoint is for initial load and final safety sync only.

## 7) Quality Workflow

Recommended before commit:

```bash
fvm flutter pub get
fvm flutter analyze
fvm flutter test
```

## 8) Build and Release

- Use build scripts in `lib/scripts/`:
  - Windows: `build.ps1`
  - macOS/Linux: `build.sh`
- Keep `.env.local` and `.env.prod` out of git.
- Client distribution guidance:
  - `documentations/BUILD_FOR_CLIENT.md`
  - `documentations/SECURE_CONFIG_SETUP.md`

## 9) Product & Catalog Policy

- All product names and descriptions MUST be provided in both English and Khmer.
- Organic products MUST include mandatory traceability data: Farm Name/Location, Farming Method (Certified Organic, Pesticide Free, or Naturally Grown), and optional Harvest Date.
- Use localized unit labels (kg, bunch, bundle) for pricing to ensure clarity for Khmer users.

## 10) Helpful References

- Architecture summary: `documentations/development_summary.md`
- Lint/coding policy: `documentations/VERY_GOOD_RULES.md`
- API endpoints: `lib/core/constants/api_endpoints.dart`
- App config: `lib/core/config/app_config.dart`
