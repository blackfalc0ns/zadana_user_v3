import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/login_form_wrapper.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleStateChanges(BuildContext context, LoginState state) {
    if (state.isSuccess && state.loginResponse != null) {
      context.read<LoginViewModel>().clearFeedback();
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
              !state.isLoading &&
              !state.isSuccess &&
              state.failure != null;

          return AuthExperienceShell(
            heroBadge: 'Ù…Ø±Ø­Ø¨Ø§ Ø¨Ø¹ÙˆØ¯ØªÙƒ',
            heroTitle: 'ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„',
            heroSubtitle:
                'Ø³Ø¬Ù„ Ø§Ù„Ø¯Ø®ÙˆÙ„ Ù„Ù„Ù…ØªØ§Ø¨Ø¹Ø© ÙˆØ§Ø³ØªØ¹Ø±Ø§Ø¶ Ø§Ù„Ù…Ù†ØªØ¬Ø§Øª',
            sectionBadge: 'Member',
            sectionTitle: 'ØªØ³Ø¬ÙŠÙ„ Ø¯Ø®ÙˆÙ„',
            sectionDescription:
                'Ø£Ø¯Ø®Ù„ Ø¨Ø±ÙŠØ¯Ùƒ Ø§Ù„Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠ Ø£Ùˆ Ø±Ù‚Ù… Ø§Ù„Ø¬ÙˆØ§Ù„ ÙˆÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ù„Ù„ÙˆØµÙˆÙ„ Ø¥Ù„Ù‰ Ø­Ø³Ø§Ø¨Ùƒ.',
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
              actionLabel: 'Ø³Ø¬Ù„ Ø­Ø³Ø§Ø¨ Ø¬Ø¯ÙŠØ¯',
              onTap: () => context.pushNamed(AppRoutes.signUp),
            ),
          );
        },
      ),
    );
  }
}
