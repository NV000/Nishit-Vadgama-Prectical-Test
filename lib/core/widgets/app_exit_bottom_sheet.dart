import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

/// Modal confirmation bottom sheet displayed when the user attempts
/// to exit or close the application from the root view.
class AppExitBottomSheet extends StatelessWidget {
  final String? title;
  final String? message;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppExitBottomSheet({
    super.key,
    this.title,
    this.message,
    this.cancelText,
    this.confirmText,
    this.onConfirm,
    this.onCancel,
  });

  /// Displays the modal confirmation bottom sheet.
  ///
  /// Returns `true` if the user confirmed exit, or `false`/`null` if cancelled.
  /// If [onConfirm] is omitted, defaults to calling [SystemNavigator.pop].
  static Future<bool?> show({
    BuildContext? context,
    String? title,
    String? message,
    String? cancelText,
    String? confirmText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    final ctx = context ?? Get.context;
    if (ctx == null) return Future.value(false);

    return showModalBottomSheet<bool>(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => AppExitBottomSheet(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = title ?? "Exit App";
    final effectiveMessage =
        message ?? "Are you sure you want to exit the app?";
    final effectiveCancel = cancelText ?? "Stay";
    final effectiveConfirm = confirmText ?? "Exit";

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.s24,
          AppSizes.s12,
          AppSizes.s24,
          AppSizes.s24,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizes.s24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle pill
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AppSizes.s20.heightBox,
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.error.withValues(alpha: 0.1),
                border: Border.all(
                  color: context.colorScheme.error.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.power_settings_new_rounded,
                  color: context.colorScheme.error,
                  size: 32,
                ),
              ),
            ),
            AppSizes.s16.heightBox,

            // Header Title
            Text(
              effectiveTitle,
              style: AppTextStyle.h3.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            AppSizes.s8.heightBox,

            // Description / Message
            Text(
              effectiveMessage,
              style: AppTextStyle.bodyMedium.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            AppSizes.s24.heightBox,

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: context.colorScheme.outline.withValues(
                          alpha: 0.4,
                        ),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.s12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.s12,
                      ),
                      backgroundColor: context.colorScheme.surface,
                      elevation: 0,
                    ),
                    child: Text(
                      effectiveCancel,
                      style: AppTextStyle.titleMedium.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                AppSizes.s16.widthBox,

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      if (onConfirm != null) {
                        onConfirm!();
                      } else {
                        SystemNavigator.pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.s12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.s12,
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.exit_to_app_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        AppSizes.s8.widthBox,
                        Text(
                          effectiveConfirm,
                          style: AppTextStyle.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
