import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class TrackOrderDeliveryOtpCard extends StatelessWidget {
  const TrackOrderDeliveryOtpCard({super.key, required this.onViewOtp});

  final VoidCallback onViewOtp;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

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
