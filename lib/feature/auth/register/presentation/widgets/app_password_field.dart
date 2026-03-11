import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';

/// Password field — wraps [AppTextField] with a show/hide toggle.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    this.hint = 'P@ssw0rd123',
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hint: widget.hint,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      prefixIcon: const Icon(
        Icons.lock_outline_rounded,
        color: AppColors.textSecondary,
       size: Spacing.iconSm,
      ),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textSecondary,
          size: Spacing.iconSm,
        ),
      ),
    );
  }
}