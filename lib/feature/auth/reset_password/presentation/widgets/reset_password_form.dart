import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_event.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_state.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_view_model.dart';

/// Reset password form widget
/// Following requirements:
/// - No setState
/// - Dispatches events to ViewModel
/// - Uses ColorScheme
/// - Reuses existing widgets
class ResetPasswordForm extends StatefulWidget {
  final String identifier;

  const ResetPasswordForm({
    super.key,
    required this.identifier,
  });

  @override
  State<ResetPasswordForm> createState() =>
      _ResetPasswordFormState();
}

class _ResetPasswordFormState
    extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final requestEntity = ResetPasswordRequestEntity(
        identifier: widget.identifier,
        otpCode: _otpController.text,
        newPassword: _newPasswordController.text,
      );

      context.read<ResetPasswordViewModel>().doIntent(
            ResetPasswordSubmitEvent(
              requestEntity: requestEntity,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;

    return BlocBuilder<
        ResetPasswordViewModel,
        ResetPasswordState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // OTP Code field
              FieldLabel(locale.label_verification_code),
              AppTextField(
                controller: _otpController,
                hint: locale.hint_verification_code,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    Validations.validOtp(context, value),
                prefixIcon: Icon(
                  Icons.pin_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.base),

              // New Password field
              FieldLabel(locale.label_new_password),
              AppPasswordField(
                controller: _newPasswordController,
                hint: locale.hint_new_password,
                validator: (v) =>
                    Validations.validatePassword(context, v),
              ),
              const SizedBox(height: Spacing.xl),

              // Submit button
              AppButtonSwitch(
                label: locale.btn_confirm,
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
