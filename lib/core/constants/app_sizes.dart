import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';

/// Centralized UI dimensions, paddings, border radiuses, and icon sizes.
class AppSizes {
  AppSizes._();

  // Spacings & Margins
  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s30 = 30.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;

  // BorderRadius objects
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(24));

  static const EdgeInsets screenhorizontalPadding = EdgeInsets.only(
    left: AppSizes.s20,
    right: AppSizes.s20,
    bottom: bottomNavBarHeight,
  );

  // Component Specific
  static const double appBarHeight = 24.0;
  static const double bottomNavBarHeight = 64.0;
  static const double cardElevation = 2.0;

  static BoxDecoration appDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: radiusXl,
    border: Border.all(color: Color(0xFFE5E7EB), width: 1.2),
  );
}
