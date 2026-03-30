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

  // Legacy aliases (backward compatibility)
  static const Color primaryGreen = primary;
  static const Color primaryDarkGreen = primaryDark;
  static const Color darkGreen = Color(0xFF1E3616);
  static const Color brownAccent = secondary;
}
