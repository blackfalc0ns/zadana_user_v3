import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/reset_password_form.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/reset_password_header.dart';

class ResetPasswordScreen extends StatelessWidget {
  final Map<String, String> arguments;

  const ResetPasswordScreen({
    super.key,
    required this.arguments,
  });

  String get identifier => arguments['identifier'] ?? '';
  String get otpCode => arguments['otpCode'] ?? '';

  @override
  Widget build(BuildContext context) {
    return _ResetPasswordView(
      identifier: identifier,
      otpCode: otpCode,
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  final String identifier;
  final String otpCode;

  const _ResetPasswordView({
    required this.identifier,
    required this.otpCode,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        backgroundColor: color.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: color.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.screenV,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and description
              ResetPasswordHeader(identifier: identifier),
              const SizedBox(height: Spacing.xl),

              // Form with fields and submit button
              ResetPasswordForm(
                identifier: identifier,
                otpCode: otpCode,
                onSuccess: () {
                  CustomSnackbar.showSuccess(
                    context: context,
                    message: locale.msg_password_reset_success,
                  );
                  context.pushNamedAndRemoveUntil(
                    AppRoutes.signUp,
                    predicate: (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
