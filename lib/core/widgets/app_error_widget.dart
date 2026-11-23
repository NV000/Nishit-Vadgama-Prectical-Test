import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/extensions/num_extension.dart';
import 'package:nishit_vadgama/core/widgets/app_button.dart';

/// Clean error state display widget with optional retry button.
class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String retryText;
  final VoidCallback? onRetry;
  final bool isNoInternet;

  const AppErrorWidget({
    super.key,
    this.title = 'Something Went Wrong',
    this.message = 'An unexpected error occurred. Please try again.',
    this.icon = Iconsax.warning_2,
    this.retryText = 'Try Again',
    this.onRetry,
    this.isNoInternet = false,
  });

  factory AppErrorWidget.noInternet({
    Key? key,
    VoidCallback? onRetry,
    String? message,
  }) {
    return AppErrorWidget(
      key: key,
      title: 'No Internet Connection',
      message:
          message ??
          'Please check your cellular or Wi-Fi network and try again.',
      icon: Iconsax.wifi_square,
      onRetry: onRetry,
      isNoInternet: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = isNoInternet
        ? context.colorScheme.secondary
        : context.colorScheme.error;

    return Center(
      child: Padding(
        padding: AppSizes.s24.allPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppSizes.s20.allPadding,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppSizes.s48, color: accentColor),
            ),
            AppSizes.s20.heightBox,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
            ),
            AppSizes.s8.heightBox,
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              AppSizes.s24.heightBox,
              AppButton(
                text: retryText,
                onPressed: onRetry,
                width: 160,
                backgroundColor: accentColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
