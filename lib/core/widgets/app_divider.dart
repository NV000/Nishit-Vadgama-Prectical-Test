import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';

class AppDivider extends StatelessWidget {
  final Color? color;
  final double? height, horizontalSpace;
  const AppDivider({super.key, this.color, this.height, this.horizontalSpace});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? context.colorScheme.outlineVariant,
      height: height ?? AppSizes.s10,
      indent: horizontalSpace,
      endIndent: horizontalSpace,
    );
  }
}
