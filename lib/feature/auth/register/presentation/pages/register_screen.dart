import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/widgets/sign_up_form.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_entity.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, this.locationEntity});

  final LocationEntity? locationEntity;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      showBackButton: true,
      heroBadge: 'ابدأ رحلتك الشرائية',
      heroTitle: 'إنشاء حساب',
      heroSubtitle:
          'أنشئ حسابك بسهولة وابدأ في حفظ العناوين والطلبات والاستفادة من تجربة تسوق مرتبة وسريعة.',
      sectionBadge: 'New account',
      sectionTitle: 'سجل حساب جديد',
      sectionDescription:
          'املأ البيانات الأساسية فقط وسنكمل معك التجربة بشكل بسيط وواضح.',
      sectionIcon: Icons.person_add_alt_1_rounded,
      body: SignUpForm(locationEntity: locationEntity),
      footer: AuthPromptText(
        text: locale.footer_have_account,
        actionLabel: locale.toggle_login,
        onTap: () => context.pushReplacementNamed(AppRoutes.login),
      ),
    );
  }
}
