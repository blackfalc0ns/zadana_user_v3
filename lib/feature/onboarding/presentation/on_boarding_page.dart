import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.primary, color.primary.withValues(alpha: 0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.lg,
       // vertical: Spacing.lg,
              ),
              child: Column(
                children: [
                  // Logo
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      Assets.logoLight,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: Spacing.xl),

                  // Illustration
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        Assets.onboarding,
                        height: 350,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: Spacing.xl),

                  // Title
                  Text(
                    l10n.start_page_title,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontSize: FontSize.size24,
                      fontFamily: FontConstant.cairo,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: Spacing.sm),

                  // Subtitle
                  Text(
                    l10n.start_page_subtitle,
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),

                  const SizedBox(height: Spacing.xl * 2),

                  // Start button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.pushNamed(AppRoutes.startSelectLocationPage),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: color.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Spacing.md),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.start_page_button,
                        style: getBoldStyle(
                          fontSize: FontSize.size16,
                          fontFamily: FontConstant.cairo,
                          color: color.primary,
                        ),
                      ),
                    ),
                  ),

                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
