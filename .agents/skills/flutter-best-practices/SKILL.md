---
name: flutter-best-practices
description: "Apply this skill when writing, reviewing, or refactoring Flutter code for the FreshLeaf project. It enforces Very Good Analysis lints, modular GetX architecture, explicit typing, and consistent naming conventions. Use for creating modules, controllers, models, and UI widgets."
license: MIT
---

# Flutter Best Practices (FreshLeaf)

## 0. Toolchain & Quality (CRITICAL)
- **Always use FVM**: Every flutter or dart command MUST be prefixed with `fvm` (e.g., `fvm flutter run`).
- **Zero Issues Pass**: Any code modification MUST pass `fvm flutter analyze` with zero errors, warnings, or info-level diagnostics.
- Flutter Version: 3.32.2 (as defined in `.fvmrc`).

## 1. Modular Architecture (GetX)
- Each feature must live in `lib/app/modules/<feature_name>/`.
- Structure within a module:
  - `bindings/`: Dependency injection via `Get.lazyPut`.
  - `controllers/`: Business logic and state management.
  - `views/`: Main UI entry point.
  - `widgets/`: Extracted reusable components.
- **No private nested widgets in view files.** Extract everything with a `build()` method to `widgets/` and use a barrel export.
- **Property Setters**: For simple property updates in controllers, use actual Dart setters (`set sort(T value)`) and corresponding getters to satisfy the `use_setters_to_change_properties` and `avoid_setters_without_getters` rules.

## 2. Typing & Safety
- **Avoid `dynamic`**: Use explicit types for all variables and API boundaries.
- **Typed Collections**: Always use `<T>` (e.g., `List<ProductModel>`).
- **Safe Conversions**: Avoid `as` casts. Use helper methods for conversion.
- **Generic GetX**: Use `Get.toNamed<T>(...)` and `Get.find<ControllerType>()`.

## 3. Naming Conventions
- **Descriptive Names**: Prefer `currentPaymentMethod` over `curPM`.
- **Boolean Prefixing**: Use `is`, `has`, or `should` (e.g., `isDefaultPaymentEnabled`).
- **No Abbreviations**: Avoid shortened names that lose meaning (e.g., `zip` -> `billingZipCode`).

## 4. API & Error Handling
- **ApiResponse Parsing**: Always parse backend envelopes through `ApiResponse` first (`ApiResponse.parseMap`, `ApiResponse.parseList`).
- **Shared Helpers**: Use `parseApiErrorMessage(error)` and `normalizeCambodiaPhoneForApi(phone)`.
- **Dio Specifics**: Catch `DioException` specifically.

## 5. UI & Styling
- **Line Length**: Max 80 characters. Wrap long expressions.
- **Refactoring over Ignoring**: If a line exceeds 80 characters (especially complex widget trees or calculation strings), extract the logic into private helper methods or `Builder` widgets instead of using `// ignore` comments.
- **Trailing Commas**: Always include trailing commas for cleaner diffs and better formatting.
- **Image Fallbacks**: All `Image.network` calls MUST include `loadingBuilder` and `errorBuilder`.

## 6. Laravel API Interaction
- For **file upload + update** (POST requests):
  - Use `multipart/form-data`.
  - Include `_method` field: `PATCH` (partial) or `PUT` (full).
