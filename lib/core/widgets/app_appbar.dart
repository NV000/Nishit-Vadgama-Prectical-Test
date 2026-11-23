import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nishit_vadgama/core/constants/app_assets.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';
import 'package:nishit_vadgama/core/widgets/app_image.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackBtn;
  final bool showNotification;
  final Widget? customLeading;
  final Widget? customTitle;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;
  final Color? titleColor;
  final Color? backgroundColor;

  const AppAppbar({
    super.key,
    this.title = '',
    this.showBackBtn = true,
    this.showNotification = true,
    this.customLeading,
    this.customTitle,
    this.actions,
    this.onBackTap,
    this.titleColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasLeading = showBackBtn || customLeading != null;

    return AppBar(
      leading: hasLeading
          ? Padding(
              padding: const EdgeInsets.only(left: AppSizes.s20),
              child: Center(
                child:
                    customLeading ??
                    AppIconBtn(
                      icon: AppAssets.arrowLeftIcon,
                      onTap: () {
                        if (onBackTap != null) {
                          onBackTap!();
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      },
                    ),
              ),
            )
          : null,
      leadingWidth: hasLeading ? (AppSizes.s20 + 44) : 0,
      automaticallyImplyLeading: false,
      titleSpacing: hasLeading ? AppSizes.s12 : AppSizes.s20,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? context.colorScheme.primary,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title:
          customTitle ??
          Text(
            title,
            style: AppTextStyle.h3.copyWith(
              color: titleColor ?? context.colorScheme.surface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}

class AppIconBtn extends StatelessWidget {
  final String icon;
  final Color? iconColor, bgColor;
  final double? iconSize, radius;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const AppIconBtn({
    super.key,
    required this.icon,
    this.iconColor,
    this.bgColor,
    this.iconSize,
    this.radius,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius != null
            ? BorderRadius.circular(radius!)
            : AppSizes.radiusXl,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor ?? AppColors.primaryDark,
            borderRadius: radius != null
                ? BorderRadius.circular(radius!)
                : AppSizes.radiusXl,
          ),
          padding: padding ?? const EdgeInsets.all(AppSizes.s8),
          child: AppImage(
            path: icon,
            color: iconColor ?? context.colorScheme.surface,
            height: iconSize ?? AppSizes.s24,
          ),
        ),
      ),
    );
  }
}
