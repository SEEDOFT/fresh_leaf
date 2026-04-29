# Very Good Analysis Rules

FreshLeaf includes `package:very_good_analysis/analysis_options.yaml`.
The current `pubspec.lock` resolves `very_good_analysis` to `9.0.0`.
If the lockfile changes, inspect the installed package rule file again before
assuming these details still match.

## Analyzer Baseline
- Assume strict casts, strict inference, and strict raw types are enabled.
- Avoid `dynamic`, implicit `dynamic`, raw collections, and loose API
  boundaries.
- Prefer typed parsing helpers over `as` casts. If a cast is unavoidable, keep
  it local, guarded, and easy to audit.
- Missing required parameters and missing returns are errors.
- Unrelated collection lookups and equality checks are warnings; keep compared
  and searched values type-compatible.

## Imports And Files
- Use package imports for `lib` code, for example
  `package:fresh_leaf/app/modules/...`.
- Do not use relative imports that cross `lib` boundaries.
- Order directives consistently: Dart, package, then project imports.
- Keep file names snake_case and library/type names Dart-conventional.
- Do not import implementation files from another package.
- End every file with a newline.

## Types And APIs
- Declare return types on functions, methods, getters, and callbacks assigned
  to named members.
- Annotate public APIs and non-obvious property types.
- Prefer local type inference for obvious locals; do not add redundant local
  types just to restate the initializer.
- Use generic GetX and route APIs, such as `Get.find<CartController>()` and
  `Get.toNamed<ResultType>(...)`.
- Prefer typed collections: `List<ProductModel>`, `Map<String, Object?>`, and
  `RxList<AddressModel>`.
- Use enums or sealed domain types instead of stringly typed modes.

## Async And Error Handling
- Await futures or intentionally mark them with `unawaited`.
- Do not use `async` functions that return `void` except valid framework
  callbacks.
- Catch specific exception types with `on`, especially `DioException` for API
  calls.
- Do not catch `Error`; let programmer errors surface.
- Use `rethrow` when preserving stack traces.
- Do not use `BuildContext` after an async gap unless the widget is still
  mounted.
- Avoid slow async file IO in UI paths.

## Immutability And Constructors
- Prefer `const` constructors, const literals, and const declarations.
- Prefer `final` locals, fields, and loop variables when values do not change.
- Use initializing formals and `super` parameters where they reduce boilerplate.
- Put required named parameters first.
- Avoid positional boolean parameters; use named booleans with clear names.
- Do not assign to parameters.

## Formatting
- Keep lines at 80 characters or less.
- Preserve trailing commas so `dart format` creates stable multiline layouts.
- Use single quotes unless interpolation or escaping makes another form clearer.
- Sort child properties last in widgets.
- Sort constructors before other members when practical.
- Prefer collection literals, spreads, if elements, and null-aware operators.

## Prohibited Or Discouraged Patterns
- Do not use `print`; use the project logging or error-reporting pattern.
- Do not rely on `runtimeType.toString`.
- Do not create empty catches, empty else blocks, or empty statements.
- Do not use unnecessary containers; prefer `ColoredBox`, `SizedBox`, or direct
  layout widgets.
- Do not use redundant getters/setters. When a setter changes controller state,
  provide a matching getter.
- Avoid cascades with a single operation.
- Avoid `// ignore` comments. If one is truly necessary, document it and keep
  it scoped to the exact lint.
- `public_member_api_docs` is disabled in FreshLeaf's project override, so do
  not add noisy docs solely to satisfy that rule.
