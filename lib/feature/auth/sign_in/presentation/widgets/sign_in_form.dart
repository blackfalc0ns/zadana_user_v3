import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_event.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_password_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final loginRequestEntity = LoginRequestEntity(
        identifier: _emailOrPhoneController.text,
        password: _passwordController.text,
      );

      context.read<LoginViewModel>().doIntent(
        LoginSubmitEvent(requestEntity: loginRequestEntity),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _emailOrPhoneController,
                  hint: locale.hint_email_or_phone,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => Validations.validateRequired(context, v),
                  prefixIcon: Icon(Iconsax.sms, color: color.primary),
                  isFilled: true,
                  filledColor: color.primary.withValues(alpha: 0.1),
                  hintColor: color.primary,
                ),
                const SizedBox(height: Spacing.base),

                AppPasswordField(
                  controller: _passwordController,
                  hint: locale.hint_password,
                  validator: (v) => Validations.validatePassword(context, v),
                ),
                const SizedBox(height: Spacing.sm),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to forgot password
                    },
                    child: Text(
                      locale.btn_forgot_password,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                
                AppButton(
                  text: locale.btn_login,
                  onPressed: () => _onSubmit(context),
                  height: 45,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
