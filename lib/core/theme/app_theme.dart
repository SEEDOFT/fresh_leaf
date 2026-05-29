import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:fresh_leaf/core/theme/app_sizes.dart';

final class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const lightScheme = ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.chipBackground,
      onSecondaryContainer: AppColors.accentBrown,
      error: AppColors.error,
      onSurface: AppColors.textDark,
      onSurfaceVariant: AppColors.textLight,
      outline: AppColors.grayBorder,
      shadow: AppColors.shadow,
      scrim: AppColors.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamilyFallback: const ['NotoSansKhmer'],
      scaffoldBackgroundColor: AppColors.backgroundCream,
      primaryColor: AppColors.primary,
      colorScheme: lightScheme,
      dividerColor: AppColors.divider,
      disabledColor: AppColors.textMuted,
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.backgroundCream,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.textDark),
        headlineMedium: TextStyle(color: AppColors.textDark),
        headlineSmall: TextStyle(color: AppColors.textDark),
        titleLarge: TextStyle(color: AppColors.textDark),
        titleMedium: TextStyle(color: AppColors.textDark),
        titleSmall: TextStyle(color: AppColors.textDark),
        bodyLarge: TextStyle(color: AppColors.textDark),
        bodyMedium: TextStyle(color: AppColors.textDark),
        bodySmall: TextStyle(color: AppColors.textLight),
        labelLarge: TextStyle(color: AppColors.textDark),
        labelMedium: TextStyle(color: AppColors.textLight),
        labelSmall: TextStyle(color: AppColors.textLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textMuted.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeSizes.buttonRadius),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeSizes.outlinedButtonRadius,
            ),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBackground,
        selectedColor: AppColors.accentLime.withValues(alpha: 0.45),
        disabledColor: AppColors.grayBorder,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.chipRadius),
        ),
        labelStyle: const TextStyle(color: AppColors.textDark),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.surface;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.grayBorder;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        hintStyle: const TextStyle(color: AppColors.inputHintColor),
        labelStyle: const TextStyle(color: AppColors.textLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.inputRadius),
          borderSide: const BorderSide(color: AppColors.grayBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.inputRadius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const darkScheme = ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: Color(0xFF242E28),
      surfaceContainerHigh: Color(0xFF2A362E),
      surfaceContainer: Color(0xFF212B25),
      surfaceContainerLow: Color(0xFF1E2621),
      surfaceContainerLowest: Color(0xFF0D120F),
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      shadow: AppColors.darkShadow,
      scrim: AppColors.darkScrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamilyFallback: const ['NotoSansKhmer'],
      scaffoldBackgroundColor: AppColors.darkScaffold,
      colorScheme: darkScheme,
      primaryColor: darkScheme.primary,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFE8EFE7),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xFF111713),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Color(0xFFE8EFE7)),
        headlineMedium: TextStyle(color: Color(0xFFE8EFE7)),
        headlineSmall: TextStyle(color: Color(0xFFE8EFE7)),
        titleLarge: TextStyle(color: Color(0xFFE8EFE7)),
        titleMedium: TextStyle(color: Color(0xFFE8EFE7)),
        titleSmall: TextStyle(color: Color(0xFFE8EFE7)),
        bodyLarge: TextStyle(color: Color(0xFFE8EFE7)),
        bodyMedium: TextStyle(color: Color(0xFFE8EFE7)),
        bodySmall: TextStyle(color: Color(0xFFB6C2B6)),
        labelLarge: TextStyle(color: Color(0xFFE8EFE7)),
        labelMedium: TextStyle(color: Color(0xFFB6C2B6)),
        labelSmall: TextStyle(color: Color(0xFFB6C2B6)),
      ),
      cardTheme: CardThemeData(
        color: darkScheme.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkScheme.primary,
          foregroundColor: darkScheme.onPrimary,
          disabledBackgroundColor: darkScheme.primary.withValues(alpha: 0.35),
          disabledForegroundColor: darkScheme.onPrimary.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeSizes.buttonRadius),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkScheme.primary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkScheme.primary,
          side: BorderSide(color: darkScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeSizes.outlinedButtonRadius,
            ),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkChipBackground,
        selectedColor: darkScheme.primary.withValues(alpha: 0.32),
        disabledColor: AppColors.darkChipDisabled,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.chipRadius),
        ),
        labelStyle: TextStyle(color: darkScheme.onSurface),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkScheme.onPrimary;
          }
          return darkScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return darkScheme.primary;
          return AppColors.darkSwitchTrack;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInputFill,
        hintStyle: TextStyle(color: darkScheme.onSurfaceVariant),
        labelStyle: TextStyle(color: darkScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.inputRadius),
          borderSide: BorderSide(color: darkScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeSizes.inputRadius),
          borderSide: BorderSide(color: darkScheme.primary, width: 1.4),
        ),
      ),
    );
  }
}
