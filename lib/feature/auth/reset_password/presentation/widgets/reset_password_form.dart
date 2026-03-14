import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';

/// Reset password form widget
/// Only for entering new password (OTP already verified)
class ResetPasswordForm extends StatefulWidget {
  final String identifier;
  final String otpCode;
  final VoidCallback onSuccess;

  const ResetPasswordForm({
    super.key,
    required this.identifier,
    required this.otpCode,
    required this.onSuccess,
  });

  @override
  State<ResetPasswordForm> createState() =>
      _ResetPasswordFormState();
}

class _ResetPasswordFormState
    extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      if (mounted) {
        widget.onSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Password field
          FieldLabel(locale.label_new_password),
          AppPasswordField(
            controller: _newPasswordController,
            hint: locale.hint_new_password,
            validator: (v) =>
                Validations.validatePassword(context, v),
          ),
          const SizedBox(height: Spacing.base),

          // Confirm Password field
          FieldLabel(locale.label_new_password),
          AppPasswordField(
            controller: _confirmPasswordController,
            hint: locale.hint_new_password,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return locale.confirm_password_is_required;
              }
              if (v != _newPasswordController.text) {
                return locale.passwords_do_not_match;
              }
              return null;
            },
          ),
          const SizedBox(height: Spacing.xl),

          // Submit button
          AppButtonSwitch(
            label: locale.btn_confirm,
            onPressed: () => _onSubmit(context),
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
