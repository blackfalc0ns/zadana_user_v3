import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/onbording/presentation/widgets/glass_button_widget.dart';
import 'package:zadana_user_v3/feature/onbording/presentation/widgets/logo_widget.dart';
import 'package:zadana_user_v3/feature/onbording/presentation/widgets/text_button_widget.dart';
import 'package:zadana_user_v3/feature/onbording/presentation/widgets/title_widget.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppConstants.onboarding, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.onSurface.withValues(alpha: 0.3),
                    color.onSurface.withValues(alpha: 0.05),
                    color.onSurface.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LogoWidget(logoAsset: AppConstants.logoDark),
                    ],
                  ),
                  const Spacer(flex: 1),

                  const SizedBox(height: Spacing.lg),

                  TitleWidget(),

                  const SizedBox(height: Spacing.sm),

                  const Spacer(flex: 2),

                  GlassButtonWidget(text: 'تسجيل الدخول', ),

                  const SizedBox(height: Spacing.md),

                  GlassButtonWidget(
                    text: 'إنشاء حساب',
                  
                    isSecondary: true,
                  ),

                  const SizedBox(height: Spacing.lg),

                  TextButtonWidget(
                    text: 'استمر كضيف',
                 
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
