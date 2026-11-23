import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/app_image.dart';

class AppChip extends StatelessWidget {
  final String text;
  final String? prefixImage;
  final VoidCallback? onTap;
  final Color? bgColor, textColor, borderColor;
  final bool isSelected;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final double? radius;

  const AppChip({
    super.key,
    required this.text,
    this.bgColor,
    this.textColor,
    this.onTap,
    this.isSelected = false,
    this.padding,
    this.textStyle,
    this.radius,
    this.borderColor,
    this.prefixImage,
  });

  @override
  Widget build(BuildContext context) {
    var finalBgColor =
        bgColor ??
        (isSelected
            ? context.colorScheme.primary
            : context.colorScheme.onSecondary);
    var finalTextColor =
        textColor ??
        (isSelected
            ? context.colorScheme.surface
            : context.colorScheme.primary);
    return InkWell(
      onTap: onTap,
      borderRadius: radius != null
          ? BorderRadius.circular(radius!)
          : AppSizes.radiusXl,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: radius != null
              ? BorderRadius.circular(radius!)
              : AppSizes.radiusXl,
          color: finalBgColor,
          border: Border.all(color: borderColor ?? context.colorScheme.surface),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            if (prefixImage != null)
              AppImage(path: prefixImage!, height: 18, color: textColor),
            Text(
              text,
              textAlign: TextAlign.center,
              style:
                  textStyle ??
                  AppTextStyle.bodyMedium.copyWith(
                    color: finalTextColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
