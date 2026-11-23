import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';

class AppGredientCard extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final List<Color>? gredients;
  final Color? roundColor;
  final EdgeInsets? padding;
  final Size? roundSize;
  const AppGredientCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.roundSize,
    this.gredients,
    this.roundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? AppSizes.radiusXl,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gredients ?? AppColors.primaryGrdeients,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -40,
            child: Container(
              height: roundSize?.height ?? 210,
              width: roundSize?.width ?? 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: roundColor ?? context.colorScheme.surface.withAlpha(15),
              ),
            ),
          ),
          Padding(padding: padding ?? const EdgeInsets.all(18), child: child),
        ],
      ),
    );
  }
}
