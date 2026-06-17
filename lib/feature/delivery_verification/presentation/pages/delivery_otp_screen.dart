import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class DeliveryOtpScreen extends StatelessWidget {
  const DeliveryOtpScreen({
    super.key,
    this.courierName,
    this.otpCode,
  });

  final String? courierName;
  final String? otpCode;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;
    final code = otpCode?.trim() ?? '';

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(title: locale.delivery_otp_title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            const SizedBox(height: Spacing.xl),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_shipping_outlined,
                size: 50,
                color: color.primary,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              locale.delivery_code_title,
              style: getBoldStyle(
                fontSize: FontSize.size22,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                locale.delivery_code_share_instruction,
                style: getRegularStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    locale.delivery_code_share_label,
                    style: getMediumStyle(
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                      color: color.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    code.isEmpty ? '----' : code,
                    style: getBoldStyle(
                      fontSize: 48,
                      fontFamily: FontConstant.cairo,
                      color: color.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: locale.delivery_code_shared_button,
                onPressed: () => Navigator.pop(context),
                color: color.primary,
                textColor: color.onPrimary,
                height: 56,
              ),
            ),
            const SizedBox(height: Spacing.md),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                locale.go_back,
                style: getMediumStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: color.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
