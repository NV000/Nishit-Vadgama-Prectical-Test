import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/services/localization_service.dart';

/// Reusable 2-button row selector for toggling between English and Malayalam.
/// Styled precisely according to design: solid blue for selected, outlined for unselected.
/// Uses GetX [Obx] and [LocalizationService] for reactive, stateless switching.
class LanguageSelectorWidget extends StatelessWidget {
  final double height;
  final double borderRadius;
  final Color? activeColor;
  final Color? inactiveBorderColor;
  final Color? inactiveBackgroundColor;

  const LanguageSelectorWidget({
    super.key,
    this.height = 48.0,
    this.borderRadius = AppSizes.s12,
    this.activeColor,
    this.inactiveBorderColor,
    this.inactiveBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? const Color(0xFF0F5A9E);
    final effectiveBorderColor = inactiveBorderColor ?? const Color(0xFFC7D7E8);
    final effectiveInactiveBg = inactiveBackgroundColor ?? Colors.white;

    return Obx(() {
      final isEnglish = LocalizationService.isEnglish;

      return Row(
        children: [
          // 1. English Button
          Expanded(
            child: _LanguageOptionButton(
              title: 'English',
              isSelected: isEnglish,
              height: height,
              borderRadius: borderRadius,
              activeColor: effectiveActiveColor,
              inactiveBorderColor: effectiveBorderColor,
              inactiveBackgroundColor: effectiveInactiveBg,
              onTap: LocalizationService.setEnglish,
            ),
          ),

          const SizedBox(width: AppSizes.s16),

          // 2. Malayalam Button
          Expanded(
            child: _LanguageOptionButton(
              title: 'Malayalam',
              isSelected: !isEnglish,
              height: height,
              borderRadius: borderRadius,
              activeColor: effectiveActiveColor,
              inactiveBorderColor: effectiveBorderColor,
              inactiveBackgroundColor: effectiveInactiveBg,
              onTap: LocalizationService.setMalayalam,
            ),
          ),
        ],
      );
    });
  }
}

class _LanguageOptionButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final double height;
  final double borderRadius;
  final Color activeColor;
  final Color inactiveBorderColor;
  final Color inactiveBackgroundColor;
  final VoidCallback onTap;

  const _LanguageOptionButton({
    required this.title,
    required this.isSelected,
    required this.height,
    required this.borderRadius,
    required this.activeColor,
    required this.inactiveBorderColor,
    required this.inactiveBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveBackgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isSelected ? activeColor : inactiveBorderColor,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : activeColor,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
