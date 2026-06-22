import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/verify_reset_otp_form.dart';

class VerifyResetOtpScreen extends StatefulWidget {
  const VerifyResetOtpScreen({super.key, required this.identifier});

  final String identifier;

  @override
  State<VerifyResetOtpScreen> createState() => _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState extends State<VerifyResetOtpScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      isLoading: _isLoading,
      showBackButton: true,
      heroBadge: locale.reset_password_otp_hero_badge,
      heroTitle: locale.reset_password_title,
      heroSubtitle: locale.reset_password_otp_hero_subtitle,
      sectionBadge: locale.reset_password_otp_section_badge,
      sectionTitle: locale.otp_verify_button,
      sectionDescription: locale.otp_description,
      sectionIcon: Icons.sms_outlined,
      body: VerifyResetOtpForm(
        identifier: widget.identifier,
        onLoadingChanged: (isLoading) {
          if (!mounted) return;
          setState(() => _isLoading = isLoading);
        },
        onSuccess: (resetToken) {
          context.pushNamed(
            AppRoutes.resetPassword,
            arguments: {
              'identifier': widget.identifier,
              'resetToken': resetToken,
            },
          );
        },
      ),
    );
  }
}
