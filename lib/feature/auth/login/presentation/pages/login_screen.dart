import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_message_presenter.dart';
import 'package:zadana_user_v3/core/errors/error_presentation.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/login_form_wrapper.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleStateChanges(BuildContext context, LoginState state) {
    if (state.isSuccess && state.loginResponse != null) {
      context.read<LoginViewModel>().clearFeedback();
      final pendingCheckout = CheckoutFlowService().consumePendingCheckout();
      if (pendingCheckout.shouldResumeCheckout) {
        context.pushNamedAndRemoveUntil(
          AppRoutes.payment,
          arguments: pendingCheckout.vendorId,
          predicate: (Route<dynamic> route) => false,
        );
        return;
      }
      context.pushNamedAndRemoveUntil(
        AppRoutes.mainShell,
        predicate: (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocConsumer<LoginViewModel, LoginState>(
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
          heroBadge: locale.login_hero_badge,
          heroTitle: locale.login_hero_title,
          heroSubtitle: locale.login_hero_subtitle,
          sectionBadge: locale.login_section_badge,
          sectionTitle: locale.login_section_title,
          sectionDescription: locale.login_section_description,
          sectionIcon: Icons.lock_open_rounded,
          body: showGlobalError
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: Spacing.lg,
                  ),
                  child: ApiErrorWidget(
                    exception: failure.exception,
                    onRetry: context.read<LoginViewModel>().clearFeedback,
                  ),
                )
              : const LoginFormWrapper(),
          footer: AuthPromptText(
            text: locale.footer_no_account,
            actionLabel: locale.footer_action_signup,
            onTap: () => context.pushNamed(AppRoutes.signUp),
          ),
        );
      },
    );
  }
}
