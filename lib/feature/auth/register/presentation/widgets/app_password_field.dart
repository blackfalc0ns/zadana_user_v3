import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    this.hint,
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return AppTextField(
      controller: widget.controller,
      hint: widget.hint ?? locale.hint_password,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      prefixIcon: Icon(
        Icons.lock_outline_rounded,
        color: color.onSurfaceVariant,
        size: Spacing.iconSm,
      ),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: color.onSurfaceVariant,
          size: Spacing.iconSm,
        ),
      ),
    );
  }
}