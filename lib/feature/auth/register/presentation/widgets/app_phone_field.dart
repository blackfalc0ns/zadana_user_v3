import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';

/// Phone field with a country-code prefix.
class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    required this.controller,
    this.hint = '(454) 726-0592',
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      keyboardType: TextInputType.phone,
      validator: validator,
      prefixIcon: Icon(Icons.phone,color: AppColors.textSecondary),
       

    );
  }
}
