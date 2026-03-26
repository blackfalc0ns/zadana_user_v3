import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';

class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    required this.controller,
    this.hint,
    this.validator,
  });

  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return AppTextField(
      controller: controller,
      hint: hint ?? locale.hint_phone,
      hintColor: color.primary, 
      keyboardType: TextInputType.phone,
      validator: validator,
      prefixIcon: Icon(Iconsax.call, color: color.primary,size: 20,),
      filledColor: color.primary.withValues(alpha: 0.1),
      isFilled: true,
    );
  }
}
