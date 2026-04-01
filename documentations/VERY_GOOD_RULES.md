# very_good_analysis guidelines (project policy)

- Lints enforced: from ery_good_analysis — run lutter analyze regularly.
- Imports: dart: first, then package:, then relative; alphabetize within groups.
- Required named params come before optional named params.
- Avoid dynamic unless unavoidable; add type args to API calls and navigation (Get.toNamed<T>, etc.).
- Add await for futures; avoid unawaited futures unless intentional (document with unawaited(...)).
- Catch with specific exception types (on DioException catch (e)); avoid bare catch.
- Keep lines ≤ 80 chars; wrap long strings/args.
- Prefer helper/base model utilities in lib/core/models/model.dart for parsing (formatToString, toDateTime, toBool, toDouble).
- No deprecated APIs (e.g., use LocationSettings with Geolocator).
