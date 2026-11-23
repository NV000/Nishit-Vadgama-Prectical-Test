import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

class AppFormContainer extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  const AppFormContainer({super.key, required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppSizes.appDecoration,
      padding: EdgeInsets.all(18),
      child: Column(
        spacing: 14,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                title!,
                style: AppTextStyle.bodyLarge.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ...[...children],
        ],
      ),
    );
  }
}
