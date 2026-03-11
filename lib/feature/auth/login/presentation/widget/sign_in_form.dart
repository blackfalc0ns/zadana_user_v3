import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_event.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/email_phone_input_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';

/// Login form widget
/// Following requirements:
/// - No setState
/// - Dispatches events to LoginViewModel
/// - Uses ColorScheme
/// - Minimal integration with existing UI
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
    if (_formKey.currentState!.validate()) {
      // Create login request entity
      final requestEntity = LoginRequestEntity(
        identifier: _phoneControllerOrEmail.text,
        password: _passwordController.text,
      );

      // Dispatch event to LoginViewModel
      context.read<LoginViewModel>().doIntent(
            LoginSubmitEvent(
              requestEntity: requestEntity,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone
              FieldLabel(locale.label_email_or_phone),
              EmailPhoneInputField  (controller: _phoneControllerOrEmail,),
              // AppPhoneField(
              //   controller: _phoneController,
              //   hint: locale.hint_phone,
              //   validator: (v) =>
              //       Validations.validatePhoneNumber(
              //         context,
              //         v,
              //       ),
              // ),
              const SizedBox(height: Spacing.base),

              // Password
              FieldLabel(locale.label_password),
              AppPasswordField(
                controller: _passwordController,
                hint: locale.hint_password,
                validator: (v) =>
                    Validations.validatePassword(
                      context,
                      v,
                    ),
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.forgetPassword);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.sm,
                      horizontal: Spacing.xs,
                    ),
                  ),
                  child: Text(
                    locale.btn_forgot_password,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),

              // Submit button
              AppButtonSwitch(
                label: locale.btn_login,
                onPressed: () => _onSubmit(context),
                isLoading: state.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
