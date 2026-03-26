import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable text field with consistent styling.
/// ─────────────────────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final bool isFilled;
  final Color filledColor;
  final Color? hintColor;
  final bool showBorder;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.contentPadding,
    this.autofocus = false,
    this.isFilled = false,
    this.filledColor = Colors.transparent,
    this.hintColor,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      autofocus: autofocus,
      style: AppTextStyles.input,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: getMediumStyle(
          fontFamily: FontConstant.cairo,
          color: hintColor ?? AppColors.dividerDark,
        ),
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: isFilled,
        fillColor: filledColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: showBorder ? AppColors.dividerDark : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: showBorder ? AppColors.primary : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(Spacing.inputRadius),
        ),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
      ),
    );
  }
}
