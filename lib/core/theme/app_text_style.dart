import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';

/// App typography helper for consistent text styling.
class AppTextStyle {
  AppTextStyle._();

  // Headings
  static TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 0,
  );

  static TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 0,
  );

  // Subtitles / Titles
  static TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 0,
  );

  // Body
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 0,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 0,
  );

  // Labels & Captions
  static TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 0,
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 0,
  );

  static TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 0,
  );

  // Button text
  static TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 0,
  );
  static TextStyle appBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 0,
    color: AppColors.white,
  );
}
