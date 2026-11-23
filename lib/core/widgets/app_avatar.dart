import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/helper/app_helper.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/widgets.dart';

class AppAvatar extends StatelessWidget {
  final String imageUrl, name;
  final Size size;
  final double borderWidth;
  final Color? borderColor, backgroundColor;
  const AppAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.size = const Size(38, 38),
    this.borderWidth = 0,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl.isEmpty
          ? Center(
              child: Text(
                AppHelper.getInitials(name),
                style: AppTextStyle.labelLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: context.colorScheme.primary,
                ),
              ),
            )
          : AppImage(
              path: imageUrl,
              borderRadius: 100,
              height: size.height,
              width: size.width,
            ),
    );
  }
}
