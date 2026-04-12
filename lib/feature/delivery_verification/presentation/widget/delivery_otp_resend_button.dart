import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class DeliveryOtpResendButton extends StatelessWidget {
  const DeliveryOtpResendButton({
    super.key,
    required this.canResend,
    required this.resendTimer,
    required this.onResend,
  });

  final bool canResend;
  final int resendTimer;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    if (canResend) {
      return TextButton(
        onPressed: onResend,
        child: Text(
          locale.delivery_otp_resend,
          style: getBoldStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: color.primary,
          ),
        ),
      );
    }

    return Text(
      '${locale.delivery_otp_timer_prefix} $resendTimer ${locale.delivery_otp_seconds}',
      style: getRegularStyle(
        fontSize: FontSize.size14,
        fontFamily: FontConstant.cairo,
        color: color.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}

