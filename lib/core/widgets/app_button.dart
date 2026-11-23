import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

/// Simple application button supporting loading indicator, optional icon, and custom styling.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading, showArrow;
  final Widget? prefixIcon;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? backgroundColor, textColor, borderColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.width = double.infinity,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.showArrow = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppSizes.radiusXl;
    final effectiveTextColor = textColor ?? context.colorScheme.onSecondary;

    return Material(
      borderRadius: BorderRadius.circular(100),
      color: context.colorScheme.surface,
      child: InkWell(
        onTap: onPressed,
        borderRadius: effectiveRadius,
        splashColor: context.colorScheme.onSurface,
        child: Container(
          width: width,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: effectiveRadius,
            color: backgroundColor,
            border: Border.all(color: borderColor ?? Colors.transparent),
            gradient: backgroundColor == null
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: AlignmentGeometry.bottomCenter,
                    colors: [
                      context.colorScheme.primary.withAlpha(200),
                      context.colorScheme.primary,
                    ],
                  )
                : null,
          ),
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: context.colorScheme.surface,
                    size: 26,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[prefixIcon!, 8.widthBox],
                    Text(
                      text,
                      style: AppTextStyle.button.copyWith(
                        color: effectiveTextColor,
                        height: -.12,
                      ),
                    ),
                    if (showArrow == true) ...[
                      6.widthBox,
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: context.colorScheme.surface,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
