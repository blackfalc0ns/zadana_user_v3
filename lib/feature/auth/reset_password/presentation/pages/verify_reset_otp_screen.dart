import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/verify_reset_otp_form.dart';

class VerifyResetOtpScreen extends StatelessWidget {
  final String identifier;

  const VerifyResetOtpScreen({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      showBackButton: true,
      heroBadge: 'تأكيد الرمز',
      heroTitle: locale.reset_password_title,
      heroSubtitle:
          'Enter the code we sent so you can safely continue to your new password and return to shopping.',
      sectionBadge: 'OTP',
      sectionTitle: locale.otp_verify_button,
      sectionDescription: locale.otp_description,
      sectionIcon: Icons.sms_outlined,
      body: VerifyResetOtpForm(
        identifier: identifier,
        onSuccess: (otpCode) {
          CustomSnackbar.showSuccess(
            context: context,
            message: locale.otp_success_message,
          );
          context.pushNamed(
            AppRoutes.resetPassword,
            arguments: {'identifier': identifier, 'otpCode': otpCode},
          );
        },
      ),
    );
  }
}
