import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_assets.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/extensions/num_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/app_appbar.dart';
import 'package:nishit_vadgama/core/widgets/app_image.dart';

class AppIconInfoCard extends StatelessWidget {
  final String icon, subtitle, title;
  final bool showVector;
  final Color? amountColor, bgColor;
  final TextStyle? titleTextStyle, subtitleTextStyle;
  const AppIconInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amountColor,
    this.showVector = false,
    this.bgColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? context.colorScheme.onSecondary.withAlpha(100),
        borderRadius: AppSizes.radiusLg,
      ),
      child: Stack(
        children: [
          if (showVector)
            Positioned(
              top: -10,
              right: 0,
              child: AppImage(
                path: AppAssets.vectorIcon,
                height: 140,
                width: 100,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIconBtn(
                  icon: icon,
                  iconColor: context.colorScheme.primary,
                  iconSize: 22,
                  bgColor: context.colorScheme.onSecondary,
                ),
                10.heightBox,
                Text(
                  title,
                  style:
                      titleTextStyle ??
                      AppTextStyle.bodySmall.copyWith(
                        color: context.colorScheme.onSecondaryContainer,
                      ),
                ),
                6.heightBox,
                Text(
                  subtitle,
                  style:
                      subtitleTextStyle ??
                      AppTextStyle.h4.copyWith(
                        color: amountColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
