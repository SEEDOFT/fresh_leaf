# VERY_GOOD_RULES (AI Agent Policy)

This project enforces:

- `include: package:very_good_analysis/analysis_options.yaml`
- local overrides from [analysis_options.yaml](D:/Flutter/fresh_leaf/analysis_options.yaml)

AI agents must follow these rules whenever writing or modifying code.

## 1) Source of truth

- Always treat [analysis_options.yaml](D:/Flutter/fresh_leaf/analysis_options.yaml) as the lint contract.
- If a style choice conflicts with personal preference, follow lint rules first.
- Do not introduce deprecated APIs.

## 2) Typing and safety

- Avoid `dynamic` unless API boundaries require it.
- Prefer explicit generic types:
  - `Get.toNamed<T>(...)`
  - typed collections (`List<Map<String, dynamic>>`, etc.)
- Avoid unsafe casts (`as`) when conversion helpers can be used.
- Prefer shared parsing helpers in:
  - [api_response.dart](D:/Flutter/fresh_leaf/lib/core/models/api_response.dart)
  - [helper.dart](D:/Flutter/fresh_leaf/lib/shared/helpers/helper.dart)

## 3) Exceptions and error handling

- Always catch specific exceptions first:
  - `on DioException catch (e)`
  - `on FormatException catch (e)`
  - then `on Exception` if needed.
- Do not use broad `catch (e)` without type unless unavoidable.
- API/UI errors should use shared helper:
  - `parseApiErrorMessage(error, fallback: ...)`

## 4) API response handling

- Parse backend envelope through `ApiResponse` first, not inline in controllers.
- Prefer:
  - `ApiResponse.parseMap(...)`
  - `ApiResponse.parseList(...)`
  - `ApiResponse.parseString(...)`
  - `ApiResponse.parseBool(...)`
  - `ApiResponse.parseDynamic(...)`
- Keep controllers focused on business flow, not response-shape conversion.

## 5) Shared logic

- If logic appears in multiple controllers, move it to shared helpers/services.
- Current shared examples:
  - `normalizeCambodiaPhoneForApi(...)`
  - `parseApiErrorMessage(...)`
- Do not duplicate private helper methods across controllers when shared helper exists.

## 6) Imports and structure

- Keep imports grouped and ordered:
  - `dart:`
  - `package:`
  - relative imports
- Keep feature modular structure:
  - `bindings/`, `controllers/`, `views/`, `widgets/`
- Do not place large private widget classes inside views; extract to `widgets/`.

## 7) Async and side effects

- Await futures explicitly unless fire-and-forget is intentional.
- If intentional, document clearly (for example, `unawaited(...)`).
- Avoid state updates after navigation unless guaranteed safe.

## 8) Formatting and line length

- Keep code formatter-friendly and lint-friendly.
- Wrap long expressions for readability and to avoid lint violations.
- Preserve trailing commas where appropriate.

## 9) Analyzer scope notes

`analysis_options.yaml` excludes generated and platform folders.  
AI edits should focus on app code under `lib/` and avoid modifying excluded/generated output.

## 10) Laravel API update rule

- This project backend is Laravel.
- For requests that upload files and also update existing resources:
  - use `POST` with multipart/form-data
  - include `_method` override (`PATCH` for partial updates, `PUT` for full updates)
- Do not send file update requests as raw `PATCH`/`PUT` multipart unless backend contract explicitly allows it.
