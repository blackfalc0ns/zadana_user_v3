import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/verify_reset_otp_form.dart';

/// Verify OTP Screen for Password Reset
/// First step: User enters 4-digit OTP code
class VerifyResetOtpScreen extends StatelessWidget {
  final String identifier;

  const VerifyResetOtpScreen({
    super.key,
    required this.identifier,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
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
              // Header
              Text(
                locale.reset_password_title,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                locale.otp_description,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: Spacing.xl),

              // OTP Form
              VerifyResetOtpForm(
                identifier: identifier,
                onSuccess: (otpCode) {
                  CustomSnackbar.showSuccess(
                    context: context,
                    message: locale.otp_success_message,
                  );
                  // Navigate to new password screen
                  context.pushNamed(
                    AppRoutes.resetPassword,
                    arguments: {
                      'identifier': identifier,
                      'otpCode': otpCode,
                    },
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
