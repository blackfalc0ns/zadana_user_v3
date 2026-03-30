import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/widget/login_form_wrapper.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      heroBadge: 'مرحبا بعودتك',
      heroTitle: 'تسجيل الدخول',
      heroSubtitle:
          'سجل الدخول للمتابعة واستعراض المنتجات',
      sectionBadge: 'Member',
      sectionTitle: 'تسجيل دخول',
      sectionDescription:
          'أدخل بريدك الإلكتروني أو رقم الجوال وكلمة المرور للوصول إلى حسابك.',
      sectionIcon: Icons.lock_open_rounded,
      body: const LoginFormWrapper(),
      footer: AuthPromptText(
        text: locale.footer_no_account,
        actionLabel: 'سجل حساب جديد',
        onTap: () => context.pushNamed(AppRoutes.signUp),
      ),
    );
  }
}
