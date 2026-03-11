import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_event.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_state.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_view_model.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/email_phone_input_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';

/// Forget password form widget
/// Following requirements:
/// - No setState
/// - Dispatches events to ViewModel
/// - Uses ColorScheme
/// - Reuses existing widgets
class ForgetPasswordForm extends StatefulWidget {
  final void Function(String identifier) onSuccess;

  const ForgetPasswordForm({
    super.key,
    required this.onSuccess,
  });

  @override
  State<ForgetPasswordForm> createState() =>
      _ForgetPasswordFormState();
}

class _ForgetPasswordFormState
    extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final requestEntity = ForgetPasswordRequestEntity(
        identifier: _identifierController.text,
      );

      context.read<ForgetPasswordViewModel>().doIntent(
            ForgetPasswordSubmitEvent(
              requestEntity: requestEntity,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocListener<
        ForgetPasswordViewModel,
        ForgetPasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          widget.onSuccess(_identifierController.text);
        }
      },
      child: BlocBuilder<
          ForgetPasswordViewModel,
          ForgetPasswordState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email or Phone field
                FieldLabel(locale.label_email_or_phone),
                EmailPhoneInputField(
                  controller: _identifierController,
                ),
                const SizedBox(height: Spacing.xl),

                // Submit button
                AppButtonSwitch(
                  label: locale.btn_send_verification_code,
                  onPressed: () => _onSubmit(context),
                  isLoading: state.isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
