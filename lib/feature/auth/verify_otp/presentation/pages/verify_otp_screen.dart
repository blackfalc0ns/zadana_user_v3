import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_message_presenter.dart';
import 'package:zadana_user_v3/core/errors/error_presentation.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_state.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/manager/verify_otp_view_model.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/presentation/widget/verify_otp_form.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_screen.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key, this.identifier});

  final String? identifier;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider(
      create: (_) => getIt<VerifyOtpViewModel>(),
      child: BlocConsumer<VerifyOtpViewModel, VerifyOtpState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.failure != current.failure,
        listener: (context, state) {
          _handleStateChanges(context, state);

          final failure = state.failure;
          if (failure == null || !failure.exception.errorType.showSnackBar) {
            return;
          }

          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.snackBarMessage(
              context,
              failure.exception,
            ),
          );
        },
        builder: (context, state) {
          final failure = state.failure;
          final showGlobalError =
              !state.isLoading &&
              !state.isSuccess &&
              failure != null &&
              failure.exception.errorType.showFullScreen;

          return AuthExperienceShell(
            isLoading: state.isLoading,
            showBackButton: true,
            heroBadge: locale.otp_hero_badge,
            heroTitle: locale.otp_screen_title,
            heroSubtitle: locale.otp_hero_subtitle,
            sectionBadge: locale.otp_section_badge,
            sectionTitle: locale.otp_screen_title,
            sectionDescription: locale.otp_description,
            sectionIcon: Icons.verified_user_outlined,
            body: showGlobalError
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: Spacing.lg,
                    ),
                    child: ApiErrorWidget(
                      exception: failure.exception,
                      onRetry: context.read<VerifyOtpViewModel>().clearFeedback,
                    ),
                  )
                : VerifyOtpForm(identifier: identifier ?? ''),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, VerifyOtpState state) {
    if (state.isSuccess) {
      context.read<VerifyOtpViewModel>().clearFeedback();
      CustomSnackbar.showSuccess(
        context: context,
        message:
            state.verifyOtpResponse?.message ??
            context.localization.otp_success_message,
      );
      final shouldResumeCheckout = CheckoutFlowService()
          .consumePendingCheckout();
      if (shouldResumeCheckout) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PaymentScreen()),
          (route) => false,
        );
        return;
      }
      context.pushNamedAndRemoveUntil(
        AppRoutes.mainShell,
        predicate: (Route<dynamic> route) => false,
      );
    }
  }
}
