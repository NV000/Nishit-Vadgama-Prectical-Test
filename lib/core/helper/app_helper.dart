import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/extensions/num_extension.dart';

class AppHelper {
  AppHelper._();

  static void hideKeyboard([BuildContext? context]) {
    if (context != null) {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final first = firstDate ?? DateTime(1900);
    final last = lastDate ?? DateTime(2100);

    // initialDate range ke bahar na jaye, warna Flutter assertion error deta hai
    DateTime initial = initialDate ?? today;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;

    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: helpText,
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          brightness: Brightness.light,
          datePickerTheme: DatePickerThemeData(
            backgroundColor: context.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            headerBackgroundColor: context.colorScheme.primary,
            headerForegroundColor: context.colorScheme.surface,
            todayBorder: BorderSide(color: context.colorScheme.primary),

            yearOverlayColor: WidgetStatePropertyAll(
              context.colorScheme.onSurface,
            ),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.colorScheme.surface;
              } else {
                return context.colorScheme.onSecondaryContainer;
              }
            }),
            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.colorScheme.surface;
              } else {
                return context.colorScheme.onSecondaryContainer;
              }
            }),
            todayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.colorScheme.surface;
              } else {
                return context.colorScheme.onSecondaryContainer;
              }
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.primary,
            ),
          ),
        ),
        child: child!,
      ),
    );
  }

  static String getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');

    if (nameParts.length >= 2) {
      return '${nameParts[0][0].toUpperCase()}${nameParts[1][0].toUpperCase()}';
    } else {
      return name.toUpperCase();
    }
  }

  static void hideSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  static void showSuccessSnackbar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    hideSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.success.withValues(alpha: 0.95),
      colorText: AppColors.white,
      icon: const Icon(Iconsax.tick_circle, color: AppColors.white, size: 24),
      margin: 16.allPadding,
      borderRadius: AppSizes.s12,
      shouldIconPulse: false,
      barBlur: 8,
      forwardAnimationCurve: Curves.easeOutCubic,
    );
  }

  static void showErrorSnackbar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
  }) {
    hideSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.error.withValues(alpha: 0.95),
      colorText: AppColors.white,
      icon: const Icon(Iconsax.warning_2, color: AppColors.white, size: 24),
      margin: 16.allPadding,
      borderRadius: AppSizes.s12,
      shouldIconPulse: false,
      barBlur: 8,
      forwardAnimationCurve: Curves.easeOutCubic,
    );
  }

  static void showInfoSnackbar({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    hideSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration,
      backgroundColor: AppColors.primary.withValues(alpha: 0.95),
      colorText: AppColors.white,
      icon: const Icon(Iconsax.info_circle, color: AppColors.white, size: 24),
      margin: 16.allPadding,
      borderRadius: AppSizes.s12,
      shouldIconPulse: false,
      barBlur: 8,
      forwardAnimationCurve: Curves.easeOutCubic,
    );
  }

  static void showLoadingDialog({String message = 'Please wait...'}) {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s24,
              vertical: AppSizes.s20,
            ),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: AppSizes.radiusLg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Get.theme.colorScheme.primary,
                    ),
                  ),
                ),
                16.widthBox,
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    VoidCallback? onConfirm,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppSizes.radiusLg),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Get.theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back(result: true);
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Future<T?> showCustomBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return Get.bottomSheet<T>(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizes.s24),
          ),
        ),
        padding: 20.allPadding,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSizes.s16),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.outlineVariant,
                  borderRadius: AppSizes.radiusSm,
                ),
              ),
              child,
            ],
          ),
        ),
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
    );
  }
}
