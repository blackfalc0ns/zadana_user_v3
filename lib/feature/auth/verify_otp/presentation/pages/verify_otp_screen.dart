import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_state.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_view_model.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/widget/verify_otp_form.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key, this.identifier});

  final String? identifier;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VerifyOtpViewModel>(),
      child: BlocListener<VerifyOtpViewModel, VerifyOtpState>(
        listener: _handleStateChanges,
        child: AuthExperienceShell(
          showBackButton: true,
          heroBadge: 'خطوة أخيرة',
          heroTitle: AppLocalizations.of(context)!.otp_screen_title,
          heroSubtitle:
              'Confirm your code to continue into a smoother grocery experience with your account fully verified.',
          sectionBadge: 'Verify',
          sectionTitle: AppLocalizations.of(context)!.otp_screen_title,
          sectionDescription: AppLocalizations.of(context)!.otp_screen_subtitle,
          sectionIcon: Icons.verified_user_outlined,
          body: VerifyOtpForm(identifier: identifier ?? ''),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, VerifyOtpState state) {
    if (state.isSuccess) {
      CustomSnackbar.showSuccess(
        context: context,
        message:
            state.verifyOtpResponse?.message ??
            AppLocalizations.of(context)!.otp_success_message,
      );
      context.pushReplacementNamed(AppRoutes.mainShell);
    }

    if (state.errorMessage != null) {
      CustomSnackbar.showError(
        context: context,
        message: state.errorMessage.toString(),
      );
    }
  }
}
