---
name: flutter-best-practices
description: Apply this skill when writing, reviewing, or refactoring Flutter code for the FreshLeaf project. It enforces FreshLeaf's package:very_good_analysis configuration, modular GetX architecture, explicit typing, controller and widget conventions, API parsing rules, and UI safety practices for modules, controllers, models, widgets, services, and tests.
---

# Flutter Best Practices (FreshLeaf)

## Required Workflow
- Work inside `D:\FreshLeaf\fresh_leaf` for Flutter app code.
- Use FVM for Flutter and Dart commands, for example `fvm flutter analyze`.
- Keep `fvm flutter analyze` at zero errors, warnings, and info diagnostics
  after code changes.
- FreshLeaf includes `package:very_good_analysis/analysis_options.yaml` from
  `analysis_options.yaml`; treat those lint rules as the baseline.
- When lint behavior matters, confirm the locked version in `pubspec.lock` and
  inspect the installed package rule file. The current lock resolves
  `very_good_analysis` to `9.0.0`.
- Before writing or reviewing Flutter code, read the relevant rule file:
  - `rules/very_good_analysis.md` for analyzer and lint expectations.
  - `rules/flutter_writing_rules.md` for FreshLeaf architecture and code style.

## FreshLeaf Defaults
- Flutter version is `3.32.2` from `.fvmrc`.
- Feature code belongs in `lib/app/modules/<feature_name>/` using GetX
  bindings, controllers, views, and widgets.
- Firebase must be initialized in `AppBootstrap` before dependent services.
- Use the centralized `NotificationService` for FCM and local notifications.
- Parse backend envelopes through `ApiResponse` helpers before reading data.
- Use shared helpers such as `parseApiErrorMessage(error)` and
  `normalizeCambodiaPhoneForApi(phone)`.
- For Laravel file upload updates over POST, send `multipart/form-data` and
  include `_method` with `PATCH` or `PUT`.
