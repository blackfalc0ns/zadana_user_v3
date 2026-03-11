import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_state.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_view_model.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/reset_password_form.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/reset_password_header.dart';

/// Reset Password Screen
/// Allows users to reset their password using OTP
///
/// Architecture:
/// - BlocProvider provides ResetPasswordViewModel
/// - BlocListener handles side effects
/// - Reusable widgets for clean separation
///
/// Location: features/auth/reset_password/presentation/pages/
class ResetPasswordScreen extends StatelessWidget {
  final String identifier;

  const ResetPasswordScreen({
    super.key,
    required this.identifier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordViewModel>(),
      child: _ResetPasswordView(identifier: identifier),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  final String identifier;

  const _ResetPasswordView({
    required this.identifier,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;

    return BlocListener<
        ResetPasswordViewModel,
        ResetPasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: state.responseEntity?.message ??
                locale.msg_password_reset_success,
          );
          // Navigate back to login
          context.pushNamedAndRemoveUntil(
            AppRoutes.signUp,
            predicate: (route) => false,
          );
        }
        if (state.errorMessage != null) {
          CustomSnackbar.showError(
            context: context,
            message: state.errorMessage!,
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.screenH,
              vertical: Spacing.screenV,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and description
                ResetPasswordHeader(identifier: identifier),
                const SizedBox(height: Spacing.xl),

                // Form with fields and submit button
                ResetPasswordForm(identifier: identifier),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
