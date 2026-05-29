import 'package:flutter/material.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';

final class AppTextStyles {
  AppTextStyles._();

  static TextStyle get hero => TextStyle(
    fontSize: 34.scaled,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  static TextStyle get heading1 => TextStyle(
    fontSize: 24.scaled,
    fontWeight: FontWeight.w800,
  );

  static TextStyle get heading2 => TextStyle(
    fontSize: 20.scaled,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get heading3 => TextStyle(
    fontSize: 18.scaled,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get heading4 => TextStyle(
    fontSize: 16.scaled,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get body => TextStyle(
    fontSize: 14.scaled,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16.scaled,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 12.scaled,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get caption => TextStyle(
    fontSize: 11.scaled,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get label => TextStyle(
    fontSize: 14.scaled,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 12.scaled,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get button => TextStyle(
    fontSize: 16.scaled,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontSize: 14.scaled,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get price => TextStyle(
    fontSize: 18.scaled,
    fontWeight: FontWeight.w800,
  );

  static TextStyle get priceLarge => TextStyle(
    fontSize: 24.scaled,
    fontWeight: FontWeight.w800,
  );
}
