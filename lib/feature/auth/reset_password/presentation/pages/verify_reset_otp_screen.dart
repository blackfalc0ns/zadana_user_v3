import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/verify_reset_otp_form.dart';

class VerifyResetOtpScreen extends StatelessWidget {
  final String identifier;

  const VerifyResetOtpScreen({
    super.key,
    required this.identifier,
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
              Text(
                locale.reset_password_title,
                style: getBoldStyle(
                  fontSize: FontSize.size24,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                locale.otp_description,
                style: getRegularStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: Spacing.xl),

              VerifyResetOtpForm(
                identifier: identifier,
                onSuccess: (otpCode) {
                  CustomSnackbar.showSuccess(
                    context: context,
                    message: locale.otp_success_message,
                  );
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
