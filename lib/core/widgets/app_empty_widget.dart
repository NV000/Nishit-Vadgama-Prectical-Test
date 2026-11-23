import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/extensions/num_extension.dart';
import 'package:nishit_vadgama/core/widgets/app_button.dart';

/// Clean empty state placeholder widget.
class AppEmptyWidget extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const AppEmptyWidget({
    super.key,
    this.title = 'No Data Available',
    this.message,
    this.icon = Iconsax.folder_open,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                color: context.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSizes.s48,
                color: context.colorScheme.primary,
              ),
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
            if (message != null) ...[
              AppSizes.s8.heightBox,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              AppSizes.s24.heightBox,
              AppButton(text: buttonText!, onPressed: onButtonPressed),
            ],
          ],
        ),
      ),
    );
  }
}
