import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  final VoidCallback onViewAll;
  final String title;
  const SectionHeader({
    super.key,
    required this.onViewAll,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            "View All",
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
