import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.screenH,
                vertical: Spacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Spacing.sm),

                  // Logo at top
                  Image.asset(
                    AppConstants.logoDark,
                    height: 52,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(flex: 2),

                  // Onboarding Illustration - Center
                  Center(
                    child: Image.asset(
                      AppConstants.onboarding,
                      height: 420,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Welcome Text - Right Aligned
                  Text(
                    AppLocalizations.of(context)!.start_page_title,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.h1.copyWith(
                      color: theme.colorScheme.onPrimary,
                      shadows: [
                        Shadow(
                          color: AppColors.shadow,
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Spacing.xs),

                  Text(
                    AppLocalizations.of(context)!.start_page_subtitle,
                    //  textAlign: TextAlign.,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      fontSize: 18,
                    ),
                  ),

                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),

          // Button at the very bottom
          Positioned(
            left: Spacing.screenH,
            right: Spacing.screenH,
            bottom: MediaQuery.of(context).padding.bottom,
            child: AppButton.filled(
              text: AppLocalizations.of(context)!.start_page_button,
              color: theme.colorScheme.onPrimary,
              textColor: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              onPressed: () =>
                  context.pushNamed(AppRoutes.startSelectLocationPage),
            ),
          ),
        ],
      ),
    );
  }
}
