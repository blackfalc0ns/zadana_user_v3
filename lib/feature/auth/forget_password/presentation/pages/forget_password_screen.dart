import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/manager/forget_password_view_model.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/presentation/widgets/forget_password_form.dart';

/// Forget Password Screen
/// Allows users to request password reset
///
/// Location: features/auth/forget_password/presentation/pages/
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

    return AuthExperienceShell(
      showBackButton: true,
      heroBadge: 'استعادة الوصول',
      heroTitle: locale.forget_password_title,
      heroSubtitle:
          'We will help you recover access quickly so you can get back to your groceries without friction.',
      sectionBadge: 'Recovery',
      sectionTitle: locale.forget_password_title,
      sectionDescription: locale.forget_password_description,
      sectionIcon: Icons.mark_email_read_outlined,
      body: ForgetPasswordForm(
        onSuccess: (identifier) => _onSuccess(context, identifier),
      ),
    );
  }
}
