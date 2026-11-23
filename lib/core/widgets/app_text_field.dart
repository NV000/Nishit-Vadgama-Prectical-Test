import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? radius;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines, maxLegth;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextStyle? hintStyle;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormator;
  final RxBool _isObscure;

  AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.autofocus = false,
    RxBool? obscureRx,
    this.inputFormator,
    this.maxLegth,
    this.radius,
    this.hintStyle,
    this.onTap,
  }) : _isObscure = obscureRx ?? isPassword.obs;

  @override
  Widget build(BuildContext context) {
    if (isPassword) {
      return Obx(() => _buildField(context, obscureText: _isObscure.value));
    }
    return _buildField(context, obscureText: false);
  }

  Widget _buildField(BuildContext context, {required bool obscureText}) {
    Widget? suffix = suffixIcon;

    if (isPassword) {
      suffix = IconButton(
        icon: Icon(
          obscureText ? Iconsax.eye_slash : Iconsax.eye,
          size: AppSizes.s12,
          color: context.colorScheme.onSurfaceVariant,
        ),
        onPressed: () => _isObscure.toggle(),
      );
    }

    final effectiveKeyboardType =
        (textInputAction == TextInputAction.newline ||
            (maxLines > 1 && keyboardType == TextInputType.text))
        ? TextInputType.multiline
        : keyboardType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          canRequestFocus: !readOnly,
          autofocus: autofocus,
          enabled: enabled,
          maxLength: maxLegth,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: effectiveKeyboardType,
          textInputAction: textInputAction,
          validator: validator,
          inputFormatters: inputFormator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: isPassword ? 1 : maxLines,
          minLines: minLines,
          onTap: onTap,
          style: AppTextStyle.bodyLarge,
          textAlignVertical: maxLines > 1
              ? TextAlignVertical.top
              : TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [prefixIcon!],
                    ),
                  )
                : null,
            filled: true,
            fillColor: context.colorScheme.surface,
            hintStyle:
                hintStyle ??
                AppTextStyle.labelLarge.copyWith(
                  color: context.colorScheme.outline,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  height: 1,
                  fontSize: 16,
                ),
            border: OutlineInputBorder(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : AppSizes.radiusMd,
              borderSide: BorderSide(
                color: context.colorScheme.onSecondaryContainer.withValues(
                  alpha: 0.2,
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : AppSizes.radiusMd,
              borderSide: BorderSide(
                color: context.colorScheme.onSecondaryContainer.withValues(
                  alpha: 0.2,
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : AppSizes.radiusMd,
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : AppSizes.radiusMd,
              borderSide: BorderSide(color: AppColors.error, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius != null
                  ? BorderRadius.circular(radius!)
                  : AppSizes.radiusMd,
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
            labelStyle: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.darkGrey,
            ),
            counterText: "",
            counterStyle: const TextStyle(fontSize: 0),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: maxLines > 1 ? 12 : 0,
            ),
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [suffix],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
