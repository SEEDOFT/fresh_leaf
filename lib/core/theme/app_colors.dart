import 'dart:ui';

final class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF2E5321); // deep leaf green
  static const Color primaryDark = Color(0xFF1A3314);
  static const Color primaryLight = Color(0xFF3F6D2E);

  // Secondary / accent palette
  static const Color secondary = Color(0xFF9E6844); // brown accent
  static const Color accentLime = Color(0xFFB4F361);
  static const Color accentPeach = Color(0xFFFFDFD6);
  static const Color accentBrown = Color(0xFF924A26);

  // Backgrounds & surfaces
  static const Color background = Color(0xFFFBF8F2);
  static const Color backgroundCream = Color(0xFFFCF9F5);
  static const Color bgCream = Color(0xFFFCF9F5); // alias for compatibility
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF3EFE9);
  static const Color cardLight = Color(0xFFF3EFE9);
  static const Color overlay = Color(0x802E5321); // 50% primary overlay
  static const Color shadow = Color(0x33000000);
  static const Color scrim = Color(0x40000000);

  // Text & icon colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textPrimary = textDark;
  static const Color textLight = Color(0xFF6B7260);
  static const Color textMuted = Color(0xFF8C8C8C);
  static const Color textGrey = Color(0xFF8C8C8C);
  static const Color linkColor = Color(0xFF8B4513);

  // Borders & dividers
  static const Color grayBorder = Color(0xFFE5E5E5);
  static const Color divider = Color(0xFFD8D8D8);

  // Inputs
  static const Color inputHintColor = Color(0xFFBDBDBD);
  static const Color fieldFill = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF3F7D2C);
  static const Color warning = Color(0xFFF6B93B);
  static const Color error = Color(0xFFDC4C3F);
  static const Color info = Color(0xFF1E88E5);

  // Decorative / chips
  static const Color chipBackground = Color(0xFFFDE8DF);

  // Dark palette & surfaces
  static const Color darkPrimary = Color(0xFF7AB46A);
  static const Color darkOnPrimary = Color(0xFF11200B);
  static const Color darkPrimaryContainer = Color(0xFF224029);
  static const Color darkOnPrimaryContainer = Color(0xFFD4F5C9);
  static const Color darkSecondary = Color(0xFFD3A98B);
  static const Color darkOnSecondary = Color(0xFF2B1B12);
  static const Color darkSecondaryContainer = Color(0xFF4A3427);
  static const Color darkOnSecondaryContainer = Color(0xFFF7DECA);
  static const Color darkError = Color(0xFFF26B60);
  static const Color darkOnError = Color(0xFF320A08);
  static const Color darkSurface = Color(0xFF1A221D);
  static const Color darkOnSurface = Color(0xFFE8EFE7);
  static const Color darkOnSurfaceVariant = Color(0xFFB6C2B6);
  static const Color darkOutline = Color(0xFF4A574D);
  static const Color darkShadow = Color(0x66000000);
  static const Color darkScrim = Color(0x99000000);
  static const Color darkScaffold = Color(0xFF111713);
  static const Color darkSwitchTrack = Color(0xFF37443B);
  static const Color darkInputFill = Color(0xFF1F2923);
  static const Color darkChipBackground = Color(0xFF223027);
  static const Color darkChipDisabled = Color(0xFF2C3A31);

  // Legacy aliases (backward compatibility)
  static const Color primaryGreen = primary;
  static const Color primaryDarkGreen = primaryDark;
  static const Color darkGreen = Color(0xFF1E3616);
  static const Color brownAccent = secondary;
}
