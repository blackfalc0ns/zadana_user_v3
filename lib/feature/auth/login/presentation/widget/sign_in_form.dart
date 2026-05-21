import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_text_field.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_event.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneControllerOrEmail.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final requestEntity = LoginRequestEntity(
      identifier: _phoneControllerOrEmail.text.trim(),
      password: _passwordController.text,
    );

    context.read<LoginViewModel>().doIntent(
      LoginSubmitEvent(requestEntity: requestEntity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        final color = context.colorScheme;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(locale.label_email_or_phone),
              CustomTextField(
                prefix: Icon(
                  Icons.email_outlined,
                  color: color.onSurfaceVariant,
                ),
                controller: _phoneControllerOrEmail,
                hint: locale.hint_email_or_phone,
                validator: (v) => Validations.validateRequired(context, v),
              ),
              const SizedBox(height: Spacing.base),
              FieldLabel(locale.label_password),
              CustomTextField(
                prefix: Icon(
                  Icons.lock_outline_rounded,
                  color: color.onSurfaceVariant,
                ),
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: color.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                controller: _passwordController,
                hint: locale.hint_password,
                obscureText: _obscurePassword,
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
                isLoading: state.isLoading,
              ),
              const SizedBox(height: Spacing.sm),
              AppButton.outlined(
                text: locale.continue_as_guest,
                onPressed: state.isLoading
                    ? null
                    : () => context.pushNamedAndRemoveUntil(
                        AppRoutes.mainShell,
                        predicate: (Route<dynamic> route) => false,
                      ),
                color: color.primary.withValues(alpha: 0.55),
                textColor: color.primary,
                height: 52,
              ),
              const SizedBox(height: Spacing.base),
            ],
          ),
        );
      },
    );
  }
}
