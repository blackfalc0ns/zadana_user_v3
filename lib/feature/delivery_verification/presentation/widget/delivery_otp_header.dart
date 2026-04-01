import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class DeliveryOtpHeader extends StatelessWidget {
  const DeliveryOtpHeader({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.delivery_otp_subtitle,
          style: getRegularStyle(
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
            color: color.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          '${locale.delivery_otp_sent_to} $phoneNumber',
          style: getMediumStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: color.primary,
          ),
        ),
      ],
    );
  }
}
