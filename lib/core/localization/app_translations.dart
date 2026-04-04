import 'package:fresh_leaf/core/localization/translations_en.dart';
import 'package:fresh_leaf/core/localization/translations_km.dart';
import 'package:get/get.dart';

final class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': translationsEn,
    'en_US': translationsEn,
    'km': translationsKm,
    'km_KH': translationsKm,
  };
}
