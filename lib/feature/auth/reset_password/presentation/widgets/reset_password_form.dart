import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/app_password_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_event.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_state.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_view_model.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({
    super.key,
    required this.identifier,
    required this.otpCode,
    required this.onSuccess,
  });
  final String identifier;
  final String otpCode;
  final VoidCallback onSuccess;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordViewModel>().doIntent(
        ResetPasswordSubmitEvent(
          requestEntity: ResetPasswordRequestEntity(
            identifier: widget.identifier,
            otpCode: widget.otpCode,
            newPassword: _newPasswordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocConsumer<ResetPasswordViewModel, ResetPasswordState>(
      listener: (context, state) {
        if (state.isSuccess && state.responseEntity != null) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.responseEntity!.message,
          );
          widget.onSuccess();
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(locale.label_new_password),
              AppPasswordField(
                controller: _newPasswordController,
                hint: locale.hint_new_password,
                validator: (v) => Validations.validatePassword(context, v),
              ),
              const SizedBox(height: Spacing.base),
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
