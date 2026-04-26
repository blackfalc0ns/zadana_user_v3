import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class TrackOrderDeliveryOtpCard extends StatelessWidget {
  const TrackOrderDeliveryOtpCard({
    super.key,
    required this.otpCode,
    required this.onViewOtp,
  });

  final String otpCode;
  final VoidCallback onViewOtp;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final maskedOtp = otpCode.trim().isEmpty ? '----' : otpCode.trim();

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.delivery_code_section_title,
            style: getBoldStyle(
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.otp_show_instruction,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: Spacing.base),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              maskedOtp,
              style: getBoldStyle(
                fontSize: 28,
                fontFamily: FontConstant.cairo,
                color: color.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Spacing.base),
          AppButton.outlined(
            text: l10n.view_otp_code,
            icon: Icons.qr_code_rounded,
            onPressed: onViewOtp,
            color: color.primary,
            textColor: color.primary,
          ),
        ],
      ),
    );
  }
}
