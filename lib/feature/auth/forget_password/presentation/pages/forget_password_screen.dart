import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/widgets/forget_password_form.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/widgets/forget_password_header.dart';

/// Forget Password Screen
/// Allows users to request password reset
///
/// Location: features/auth/forget_password/presentation/pages/
class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ForgetPasswordView();
  }
}

class _ForgetPasswordView extends StatelessWidget {
  const _ForgetPasswordView();

  void _onSuccess(
    BuildContext context,
    String identifier,
  ) {
    final locale = context.localization;

    CustomSnackbar.showSuccess(
      context: context,
      message: locale.msg_verification_code_sent,
    );

    // Navigate to verify OTP screen
    context.pushNamed(
      AppRoutes.verifyResetOtp,
      arguments: identifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
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
              const ForgetPasswordHeader(),
              const SizedBox(height: Spacing.xl),

              // Form with field and submit button
              ForgetPasswordForm(
                onSuccess: (identifier) =>
                    _onSuccess(context, identifier),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
