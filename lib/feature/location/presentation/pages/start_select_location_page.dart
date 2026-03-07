import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class StartSelectLocationPage extends StatelessWidget {
  const StartSelectLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Spacing.lg),

              // Logo placeholder
              Container(
                // height: 40,
                // width: 120,
                // decoration: BoxDecoration(
                //   color: AppColors.primary,
                //   borderRadius: BorderRadius.circular(
                //     Spacing.buttonSmallRadius,
                //   ),
                // ),
                child: Center(
                  child: Image.asset(
                    AppConstants.logoDark,
                    height: 52,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Title
              Text(l10n.location, style: AppTextStyles.h2),

              const SizedBox(height: Spacing.md),

              // Description
              Text(
                'نحن بحاجة إلى معرفة موقعك الحالي لاقتراح أفضل الخدمات والمتاجر القريبة منك.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.start,
              ),

              const Spacer(flex: 2),

              // Location illustration placeholder
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                  ),
                  child:Image.asset(AppConstants.locationImage,)
                ),
              ),

              const Spacer(flex: 3),

              // Share location button (filled)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.selectAddress);
                  },
                  icon: const Icon(Icons.my_location, size: Spacing.iconMd),
                  label: const Text('مشاركة موقعي الحالي'),
                ),
              ),

              const SizedBox(height: Spacing.base),

              // Enter address manually button (outlined)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to manual address entry
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('أدخل العنوان يدوياً')),
                    );
                  },
                  child: const Text('أدخل العنوان يدوياً'),
                ),
              ),

              const SizedBox(height: Spacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
