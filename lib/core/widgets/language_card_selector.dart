import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/services/localization_service.dart';

/// Interactive vertical card-based language selection widget.
/// Renders two full-width cards: "English" and "Malayalam", each containing
/// a custom rounded checkbox reflecting the selected state.
class LanguageCardSelector extends StatelessWidget {
  final Color? activeColor;
  final ValueChanged<Locale>? onLanguageSelected;

  const LanguageCardSelector({
    super.key,
    this.activeColor,
    this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? const Color(0xFF0F5A9E);

    return Obx(() {
      final isEnglish = LocalizationService.isEnglish;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. English Option Card
          _LanguageCard(
            title: 'English',
            isSelected: isEnglish,
            activeColor: effectiveActiveColor,
            onTap: () {
              LocalizationService.setEnglish();
              onLanguageSelected?.call(LocalizationService.english);
            },
          ),
          const SizedBox(height: AppSizes.s14),

          // 2. Malayalam Option Card
          _LanguageCard(
            title: 'Malayalam',
            isSelected: !isEnglish,
            activeColor: effectiveActiveColor,
            onTap: () {
              LocalizationService.setMalayalam();
              onLanguageSelected?.call(LocalizationService.malayalam);
            },
          ),
        ],
      );
    });
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: activeColor.withValues(alpha: isSelected ? 0.12 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              _CustomCheckbox(isSelected: isSelected, activeColor: activeColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomCheckbox extends StatelessWidget {
  final bool isSelected;
  final Color activeColor;

  const _CustomCheckbox({required this.isSelected, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: isSelected
            ? null
            : Border.all(color: const Color(0xFF94A3B8), width: 1.5),
      ),
      child: isSelected
          ? const Center(
              child: Icon(Icons.check, size: 16, color: Colors.white),
            )
          : null,
    );
  }
}
