import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/checkout_flow_service.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/login_form_wrapper.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleStateChanges(BuildContext context, LoginState state) {
    if (state.isSuccess && state.loginResponse != null) {
      context.read<LoginViewModel>().clearFeedback();
      final shouldResumeCheckout = CheckoutFlowService()
          .consumePendingCheckout();
      if (shouldResumeCheckout) {
        context.pushNamedAndRemoveUntil(
          AppRoutes.payment,
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

    return BlocListener<LoginViewModel, LoginState>(
      listener: _handleStateChanges,
      child: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {
          final showGlobalError =
              !state.isLoading && !state.isSuccess && state.failure != null;

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
                    child: ApiErrorWidget.fromFailure(
                      state.failure!,
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
      ),
    );
  }
}
