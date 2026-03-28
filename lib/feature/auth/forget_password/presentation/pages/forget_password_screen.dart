import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/widgets/forget_password_form.dart';

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

  void _onSuccess(BuildContext context, String identifier) {
    final locale = context.localization;

    CustomSnackbar.showSuccess(
      context: context,
      message: locale.msg_verification_code_sent,
    );

    // Navigate to verify OTP screen
    context.pushNamed(AppRoutes.verifyResetOtp, arguments: identifier);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      showBackButton: true,
      heroBadge: 'استعادة الوصول',
      heroTitle: locale.forget_password_title,
      heroSubtitle:
          'We will help you recover access quickly so you can get back to your groceries without friction.',
      sectionBadge: 'Recovery',
      sectionTitle: locale.forget_password_title,
      sectionDescription: locale.forget_password_description,
      sectionIcon: Icons.mark_email_read_outlined,
      body: ForgetPasswordForm(
        onSuccess: (identifier) => _onSuccess(context, identifier),
      ),
    );
  }
}
