import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/extensions/num_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

class AppInfoCard extends StatelessWidget {
  final String title, value;
  const AppInfoCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.colorScheme.onSecondary,
        borderRadius: AppSizes.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.labelMedium.copyWith(
              color: context.colorScheme.onSecondaryContainer,
            ),
          ),
          8.heightBox,
          Text(
            value,
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
