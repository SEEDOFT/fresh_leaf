# Flutter Writing Rules

Use these rules when writing or reviewing FreshLeaf Flutter code.

## Module Structure
- Put each feature under `lib/app/modules/<feature_name>/`.
- Use this module shape:
  - `bindings/` for dependency registration with `Get.lazyPut`.
  - `controllers/` for state, side effects, and orchestration.
  - `views/` for page-level widgets.
  - `widgets/` for reusable or extracted UI pieces.
- Extract widgets with a `build()` method into `widgets/`; do not hide private
  nested widget classes inside view files.
- Add or update barrel exports when the surrounding module already uses them.

## Controllers And State
- Keep business logic in controllers or services, not views.
- Use explicit Rx types such as `RxBool`, `Rxn<UserModel>`, and
  `RxList<ProductModel>`.
- Expose simple state updates with real Dart setters and matching getters when
  that reads naturally, for example `set sort(SortOption value)`.
- Use descriptive state names such as `isSubmitting`, `hasDefaultAddress`, and
  `selectedPaymentMethod`.
- Dispose controllers, text editing controllers, workers, subscriptions, and
  other owned resources according to their lifecycle.

## Widgets And UI
- Keep page widgets focused on composition.
- Extract repeated or conditional UI into small widgets or helper methods before
  adding lint ignores for line length.
- Use `const` widgets wherever possible.
- Include keys on public reusable widgets and page widgets.
- All `Image.network` usages must include both `loadingBuilder` and
  `errorBuilder`.
- Prefer `SizedBox` for spacing and fixed dimensions.
- Prefer `ColoredBox` over `Container` when only painting a color.
- Keep widget constructor parameters named and descriptive.

## Naming
- Use descriptive names over abbreviations: `currentPaymentMethod`, not `curPM`.
- Prefix booleans with `is`, `has`, `can`, or `should`.
- Use domain-specific names for user-facing data, such as `billingPostalCode`
  instead of vague names like `zip`.
- Keep files and folders snake_case.
- Keep classes, enums, and extensions in UpperCamelCase.

## API And Data Parsing
- Parse backend envelopes through `ApiResponse.parseMap`,
  `ApiResponse.parseList`, or the matching project helper before accessing
  payload fields.
- Catch `DioException` specifically for network/API failures.
- Use `parseApiErrorMessage(error)` for user-facing API error text.
- Use `normalizeCambodiaPhoneForApi(phone)` before sending Cambodia phone
  numbers to the backend.
- Avoid exposing raw JSON maps past model factories or repository boundaries.
- Prefer model factory helpers that validate and normalize questionable input.

## Firebase And Notifications
- Initialize Firebase in `AppBootstrap` before starting services that depend on
  Firebase.
- Route FCM and local notification work through the centralized
  `NotificationService`.
- Regenerate `firebase_options.dart` with the FlutterFire CLI when Firebase
  project configuration changes.

## Laravel Upload Updates
- For file upload update requests sent as POST, use `multipart/form-data`.
- Include `_method` with `PATCH` for partial updates or `PUT` for full
  replacements.
- Keep upload field names aligned with the backend request contract.

## Formatting And Review
- Keep lines within 80 characters.
- Use trailing commas in multiline calls, constructors, collections, and widget
  trees.
- Prefer refactoring over lint suppression.
- Run `fvm flutter analyze` after edits and resolve every diagnostic.
