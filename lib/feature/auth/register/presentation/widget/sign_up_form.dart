import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/app_phone_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widget/field_label.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // ── فورم key خاصة بالريجستر بس ────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController    = TextEditingController();
  final _phoneController    = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
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
          // ── Full Name ──────────────────────────────────────────
          FieldLabel(locale.label_full_name),
          AppTextField(
            controller: _fullNameController,
            hint: locale.hint_full_name,
            keyboardType: TextInputType.name,
            validator: (v) => Validations.validateName(context, v),
            prefixIcon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: Spacing.base),

          // ── Email ──────────────────────────────────────────────
          FieldLabel(locale.label_email),
          AppTextField(
            controller: _emailController,
            hint: locale.hint_email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => Validations.validateEmail(context, v),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: Spacing.base),

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

          const SizedBox(height: Spacing.xxl),

          // ── CTA ────────────────────────────────────────────────
          AppButtonSwitch(
            label: locale.btn_signup,
            onPressed: () {
               print('>>>>>>>>>inSignUP');
              if (_formKey.currentState!.validate()) {
                context.pushNamed(AppRoutes.mainShell);
               
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}