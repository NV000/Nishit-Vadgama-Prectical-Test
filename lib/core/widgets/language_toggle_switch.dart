import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/services/localization_service.dart';

/// Minimalist toggle switch for switching between English and Malayalam.
/// Displays: English [ (o  ) ] Malayalam
/// Uses GetX [Obx] and [LocalizationService] for reactive, stateless switching.
class LanguageToggleSwitch extends StatelessWidget {
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? switchTrackColor;
  final double fontSize;

  const LanguageToggleSwitch({
    super.key,
    this.activeColor,
    this.inactiveColor,
    this.switchTrackColor,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? const Color(0xFF0F5A9E);
    final effectiveInactiveColor = inactiveColor ?? const Color(0xFF7E8B9B);
    final effectiveTrackColor = switchTrackColor ?? const Color(0xFF5B88B2);

    return Obx(() {
      final isEnglish = LocalizationService.isEnglish;

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "English" label
          GestureDetector(
            onTap: LocalizationService.setEnglish,
            behavior: HitTestBehavior.opaque,
            child: Text(
              'English',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isEnglish ? FontWeight.w700 : FontWeight.w500,
                color: isEnglish
                    ? effectiveActiveColor
                    : effectiveInactiveColor,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s12),

          // Custom toggle switch pill
          GestureDetector(
            onTap: () {
              if (isEnglish) {
                LocalizationService.setMalayalam();
              } else {
                LocalizationService.setEnglish();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: effectiveTrackColor,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: isEnglish
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s12),

          // "Malayalam" label
          GestureDetector(
            onTap: LocalizationService.setMalayalam,
            behavior: HitTestBehavior.opaque,
            child: Text(
              'Malayalam',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: !isEnglish ? FontWeight.w700 : FontWeight.w500,
                color: !isEnglish
                    ? effectiveActiveColor
                    : effectiveInactiveColor,
              ),
            ),
          ),
        ],
      );
    });
  }
}
