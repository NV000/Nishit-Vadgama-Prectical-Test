import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = "PlusJakartaSans";

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textPrimary,
    primaryContainer: Color(0xFFE0E7FF),
    onPrimaryContainer: AppColors.primary,
    secondary: AppColors.lightPrimary,
    onSecondary: AppColors.primaryPastle,
    secondaryContainer: Color(0xFFF3F4F6),
    onSecondaryContainer: AppColors.darkGrey,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: AppColors.error,
    surface: AppColors.white,
    onSurface: AppColors.black,
    onSurfaceVariant: AppColors.primaryBg,
    outline: AppColors.grey,
    outlineVariant: Color(0xFFE5E7EB),
    shadow: Colors.black12,
    tertiary: AppColors.success,
    tertiaryFixedDim: AppColors.successPastle,
    scrim: AppColors.orange,
    tertiaryFixed: Color(0XFF4338CA),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.textPrimary,
    primaryContainer: Color(0xFF312E81),
    onPrimaryContainer: AppColors.white,
    secondary: AppColors.lightPrimary,
    onSecondary: AppColors.black,
    secondaryContainer: AppColors.darkGrey,
    onSecondaryContainer: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: AppColors.white,
    surface: AppColors.darkGrey,
    onSurface: AppColors.white,
    onSurfaceVariant: AppColors.grey,
    outline: AppColors.grey,
    outlineVariant: AppColors.darkGrey,
    shadow: AppColors.black,
    tertiaryFixed: Color(0XFF4338CA),
    tertiary: AppColors.success,
    tertiaryFixedDim: AppColors.successPastle,
    scrim: AppColors.orange,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(fontFamily: fontFamily),
        toolbarTextStyle: TextStyle(fontFamily: fontFamily),
      ),

      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusMd,
          side: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey.withValues(alpha: 0.08),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s16,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.4)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.darkGrey),
        hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppSizes.radiusMd),
          textStyle: AppTextStyle.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: AppSizes.radiusMd),
          textStyle: AppTextStyle.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyle.button,
          shape: const RoundedRectangleBorder(borderRadius: AppSizes.radiusSm),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.grey.withValues(alpha: 0.25),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.black,
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        toolbarTextStyle: TextStyle(fontFamily: fontFamily),
        titleTextStyle: TextStyle(fontFamily: fontFamily),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkGrey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusMd,
          side: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s16,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppSizes.radiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey),
        hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppSizes.radiusMd),
          textStyle: AppTextStyle.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          side: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.6),
            width: 1.5,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppSizes.radiusMd),
          textStyle: AppTextStyle.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: AppTextStyle.button,
          shape: const RoundedRectangleBorder(borderRadius: AppSizes.radiusSm),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.grey.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
