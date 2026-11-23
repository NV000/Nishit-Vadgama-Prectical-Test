import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

class AppProgressbar extends StatelessWidget {
  final double value, height;
  final String? suffixValue;
  final Color? valueColor, backgroundColor;
  const AppProgressbar({
    super.key,
    required this.value,
    this.valueColor,
    this.backgroundColor,
    this.height = 4,
    this.suffixValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14,
      children: [
        Expanded(
          child: LinearProgressIndicator(
            borderRadius: AppSizes.radiusLg,
            value: value,
            minHeight: height,
            backgroundColor: backgroundColor ?? context.colorScheme.onSecondary,
            valueColor: AlwaysStoppedAnimation(
              valueColor ?? context.colorScheme.primary,
            ),
          ),
        ),
        if (suffixValue != null)
          Text(
            suffixValue!,
            style: AppTextStyle.bodySmall.copyWith(
              color: context.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
