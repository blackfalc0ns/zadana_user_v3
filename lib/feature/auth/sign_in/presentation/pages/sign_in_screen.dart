import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/app_phone_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/field_label.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKeyy = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = context.localization;
    return Form(
      key: _formKeyy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Phone ──────────────────────────────────────────────
          FieldLabel(locale.label_phone),
          AppPhoneField(
            controller: _phoneController,
            validator: (value) =>
                Validations.validatePhoneNumber(context, value),
          ),

          const SizedBox(height: Spacing.base),

          // ── Password ───────────────────────────────────────────
          FieldLabel(locale.label_password),
          AppPasswordField(
            controller: _passwordController,
            validator: (value) => Validations.validatePassword(context, value),
          ),

          // ── Forgot Password ────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.sm,
                  horizontal: Spacing.xs,
                ),
              ),
              child: Text(
                locale.btn_forgot_password,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: Spacing.md),

        ],

      ),
    );
  }
}
