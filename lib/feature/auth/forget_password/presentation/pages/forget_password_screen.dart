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
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_state.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_view_model.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/widgets/forget_password_form.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgetPasswordViewModel>(),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatelessWidget {
  const _ForgetPasswordView();

  void _onSuccess(BuildContext context, String identifier) {
    context.pushNamed(AppRoutes.verifyResetOtp, arguments: identifier);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listenWhen: (previous, current) => previous.failure != current.failure,
      listener: (context, state) {
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
          heroBadge: locale.forget_password_hero_badge,
          heroTitle: locale.forget_password_title,
          heroSubtitle: locale.forget_password_hero_subtitle,
          sectionBadge: locale.forget_password_section_badge,
          sectionTitle: locale.forget_password_title,
          sectionDescription: locale.forget_password_description,
          sectionIcon: Icons.mark_email_read_outlined,
          body: showGlobalError
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: Spacing.lg,
                  ),
                  child: ApiErrorWidget(
                    exception: failure.exception,
                    onRetry: context
                        .read<ForgetPasswordViewModel>()
                        .clearFeedback,
                  ),
                )
              : ForgetPasswordForm(
                  onSuccess: (identifier) => _onSuccess(context, identifier),
                ),
        );
      },
    );
  }
}
