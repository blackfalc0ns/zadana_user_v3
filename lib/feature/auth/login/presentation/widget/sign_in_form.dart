import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/custom_text_field.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/email_phone_input_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneControllerOrEmail = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneControllerOrEmail.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    //  if (_formKey.currentState!.validate()) {
    final _ = LoginRequestEntity(
      identifier: _phoneControllerOrEmail.text,
      password: _passwordController.text,
    );
    context.pushNamedAndRemoveUntil(
      AppRoutes.mainShell,
      predicate: (Route<dynamic> route) => false,
    );

    // context.read<LoginViewModel>().doIntent(
    //       LoginSubmitEvent(requestEntity: requestEntity),
    //     );
    //  }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel(locale.label_email_or_phone),
          CustomTextField(
            prefix: IconButton(
              icon: const Icon(Icons.email, color: AppColors.textSecondary),
              onPressed: () {},
            ),
            controller: _phoneControllerOrEmail,
            hint: locale.hint_email_or_phone,
          ),
          const SizedBox(height: Spacing.base),
          FieldLabel(locale.label_password),
          CustomTextField(
            prefix: IconButton(
              icon: const Icon(Icons.lock, color: AppColors.textSecondary),
              onPressed: () {},
            ),
            suffix: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                _passwordController.text = _passwordController.text
                    .split('')
                    .reversed
                    .join('');
              },
            ),
            controller: _passwordController,
            hint: locale.hint_password,
            validator: (v) => Validations.validatePassword(context, v),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed(AppRoutes.forgetPassword),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.sm,
                  horizontal: Spacing.xs,
                ),
              ),
              child: Text(
                locale.btn_forgot_password,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: color.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          AppButtonSwitch(
            label: locale.btn_login,
            onPressed: () => _onSubmit(context),

            // state.isLoading,
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }
}
