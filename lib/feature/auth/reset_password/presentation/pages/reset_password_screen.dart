import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/manager/reset_password_view_model.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/presentation/widgets/reset_password_form.dart';

class ResetPasswordScreen extends StatelessWidget {
  final Map<String, String> arguments;

  const ResetPasswordScreen({super.key, required this.arguments});

  String get identifier => arguments['identifier'] ?? '';
  String get otpCode => arguments['otpCode'] ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordViewModel>(),
      child: _ResetPasswordView(identifier: identifier, otpCode: otpCode),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  final String identifier;
  final String otpCode;

  const _ResetPasswordView({required this.identifier, required this.otpCode});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      showBackButton: true,
      heroBadge: 'تأمين الحساب',
      heroTitle: locale.reset_password_title,
      heroSubtitle:
          'Choose a stronger password and keep your grocery account protected across every session.',
      sectionBadge: 'Secure',
      sectionTitle: locale.reset_password_title,
      sectionDescription:
          '${locale.reset_password_description_prefix} $identifier',
      sectionIcon: Icons.password_rounded,
      body: ResetPasswordForm(
        identifier: identifier,
        otpCode: otpCode,
        onSuccess: () {
          context.pushNamedAndRemoveUntil(
            AppRoutes.login,
            predicate: (route) => false,
          );
        },
      ),
    );
  }
}
