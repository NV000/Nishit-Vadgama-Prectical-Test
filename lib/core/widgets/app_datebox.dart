import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/extensions.dart';
import 'package:nishit_vadgama/core/helper/date_helper.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

class AppDatebox extends StatelessWidget {
  final String date;
  const AppDatebox({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final month = DateHelper.month(date);
    final day = DateHelper.day(date);
    final year = DateHelper.year(date);

    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppSizes.radiusLg,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 17,
            color: context.colorScheme.primary,
            child: Center(
              child: Text(
                month,
                style: AppTextStyle.bodySmall.copyWith(
                  color: context.colorScheme.surface,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: context.colorScheme.onSurfaceVariant,
              child: Center(
                child: Text(
                  day,
                  style: AppTextStyle.bodyLarge.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 17,
            color: context.colorScheme.primary,
            child: Center(
              child: Text(
                year,
                style: AppTextStyle.bodySmall.copyWith(
                  color: context.colorScheme.surface,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
