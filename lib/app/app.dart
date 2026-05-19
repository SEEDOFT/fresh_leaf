import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fresh_leaf/app/routes/app_pages.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/localization/app_translations.dart';
import 'package:fresh_leaf/core/services/permission_service.dart';
import 'package:fresh_leaf/core/theme/app_theme.dart';
import 'package:fresh_leaf/core/widgets/app_shell_scaffold.dart';
import 'package:get/get.dart';

class FreshLeafApp extends StatefulWidget {
  const FreshLeafApp({required this.initialRoute, super.key});

  final String initialRoute;

  @override
  State<FreshLeafApp> createState() => _FreshLeafAppState();
}

class _FreshLeafAppState extends State<FreshLeafApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestStartupPermissions();
    });
  }

  Future<void> _requestStartupPermissions() async {
    try {
      await PermissionService.requestAll();
    } on Exception {
      // best-effort only
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = Get.find<AppSettingsController>();
    return Obx(
      () {
        final platformBrightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        final mode = appSettings.themeMode.value;
        final isDark =
            mode == ThemeMode.dark ||
            (mode == ThemeMode.system && platformBrightness == Brightness.dark);

        final overlayStyle = isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: const Color(0xFF111713),
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: const Color(0xFFFCF9F5),
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: widget.initialRoute,
            getPages: AppPages.pages,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appSettings.themeMode.value,
            builder: (context, child) {
              if (child == null) {
                return const SizedBox.shrink();
              }
              return AppShellScaffold(child: child);
            },
            translations: AppTranslations(),
            locale: appSettings.locale.value,
            fallbackLocale: const Locale('km', 'KH'),
            supportedLocales: const [
              Locale('en'),
              Locale('km'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        );
      },
    );
  }
}
