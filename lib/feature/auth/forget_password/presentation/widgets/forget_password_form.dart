import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/validators.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/core/widgets/custom_text_field.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_event.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_state.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_view_model.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';

/// Forget password form widget
/// Following requirements:
/// - No setState
/// - Uses ColorScheme
/// - Reuses existing widgets
class ForgetPasswordForm extends StatefulWidget {
  final void Function(String identifier) onSuccess;

  const ForgetPasswordForm({
    super.key,
    required this.onSuccess,
  });

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordViewModel>().doIntent(
        ForgetPasswordSubmitEvent(
          requestEntity: ForgetPasswordRequestEntity(
            identifier: _identifierController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        if (state.isSuccess && state.responseEntity != null) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.responseEntity!.message,
          );
          widget.onSuccess(_identifierController.text.trim());
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldLabel(locale.label_email_or_phone),
              CustomTextField(
                controller: _identifierController,
                hint: locale.hint_email_or_phone,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    Validations.validateRequired(context, value?.trim()),
              ),
              const SizedBox(height: Spacing.xl),
              AppButtonSwitch(
                label: locale.btn_send_verification_code,
                onPressed: () => _onSubmit(context),
                isLoading: state.isLoading,
              ),
              const SizedBox(height: Spacing.base),
            ],
          ),
        );
      },
    );
  }
}
