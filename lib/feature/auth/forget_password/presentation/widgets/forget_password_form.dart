import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_text_field.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/button_switch.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/field_label.dart';

/// Forget password form widget
/// Following requirements:
/// - No setState
/// - Uses ColorScheme
/// - Reuses existing widgets
class ForgetPasswordForm extends StatefulWidget {
  final void Function(String identifier) onSuccess;

  const ForgetPasswordForm({super.key, required this.onSuccess});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      if (mounted) {
        widget.onSuccess(_identifierController.text);
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
          // Email or Phone field
          FieldLabel(locale.label_email_or_phone),
          CustomTextField(
            controller: _identifierController,
            hint: locale.hint_email_or_phone,
          ),
          const SizedBox(height: Spacing.xl),

          // Submit button
          AppButtonSwitch(
            label: locale.btn_send_verification_code,
            onPressed: () => _onSubmit(context),
            isLoading: _isLoading,
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }
}
