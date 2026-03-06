import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/flutter_toast.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/app_phone_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/field_label.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // ── فورم key خاصة باللوجين بس ─────────────────────────────────
  final _formKey = GlobalKey<FormState>();

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
    final locale = context.localization;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Phone ──────────────────────────────────────────────
          FieldLabel(locale.label_phone),
          AppPhoneField(
            controller: _phoneController,
            hint: locale.hint_phone,
            validator: (v) => Validations.validatePhoneNumber(context, v),
          ),

          const SizedBox(height: Spacing.base),

          // ── Password ───────────────────────────────────────────
          FieldLabel(locale.label_password),
          AppPasswordField(
            controller: _passwordController,
            hint: locale.hint_password,
            validator: (v) => Validations.validatePassword(context, v),
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

          // ── CTA ────────────────────────────────────────────────
          AppButtonSwitch(
            label: locale.btn_login,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.pushNamed(AppRoutes.mainShell);
                ToastMessage.toastMsg(
                  'تم تسجيل الدخول بنجاح',
                  backgroundColor: AppColors.primary,
                );
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
