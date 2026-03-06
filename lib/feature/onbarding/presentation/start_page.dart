import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/routing/routing_extensions.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/constants/font_manger.dart';
import 'package:zadana_user_v3/core/constants/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color customTeal = Color(0xff08768D);

    return Scaffold(
      backgroundColor: customTeal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align text and logo to the right (RTL start)
            children: [
              const SizedBox(height: 10),
              // Logo at top right
              Image.asset(
                AppConstants.logoLight,
                height: 52,
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 2),

              // Onboarding Illustration - Center centered
              Center(
                child: Image.asset(
                  AppConstants.onboarding,
                  height: 420, // Adjusted for balance
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(flex: 5),

              // Welcome Text - Right Aligned with more impact
              Text(
                AppLocalizations.of(context)!.start_page_title,
                textAlign: TextAlign.left,
                style:
                    getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size30,
                      color: AppColors.white,
                    ).copyWith(
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.start_page_subtitle,
                textAlign: TextAlign.right,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size20,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),

              const Spacer(flex: 3),

              // Start Button - White background, Teal text, Extra Bold
              AppButton.filled(
                text: AppLocalizations.of(context)!.start_page_button,
                color: AppColors.white,
                textColor: customTeal,
                fontWeight: FontWeight.w900, // Extra bold as requested
                onPressed: ()=>context.pushNamed(AppRoutes.signUp),
                    //Navigator.pushReplacementNamed(context, Routes.home),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
