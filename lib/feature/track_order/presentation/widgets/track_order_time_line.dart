import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';

class TrackOrderTimelineTile extends StatelessWidget {
  const TrackOrderTimelineTile({
    super.key,
    required this.title,
    required this.time,
    required this.active,
    required this.last,
    required this.showButton,
  });

  final String title;
  final String time;
  final bool active;
  final bool last;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              active
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: active ? color.primary : color.secondary,
              size: 28,
            ),
            if (!last)
              Container(
                width: 2,
                height: 56,
                color: active
                    ? color.primary.withValues(alpha: .55)
                    : color.secondary.withValues(alpha: .45),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: getMediumStyle(
                          fontSize: 18,
                          fontFamily: FontConstant.cairo,
                          color: active ? color.primary : color.secondary,
                        ),
                      ),
                    ),
                    if (showButton)
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: AppButton(
                          padding: const EdgeInsets.all(0),
                          text: AppLocalizations.of(context)!.delivery_get_otp,
                          variant: AppButtonVariant.outlined,
                          color: AppColors.primary,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.deliveryOtp,
                          ),
                        ),
                      ),
                  ],
                ),
                if (active) ...[
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: getRegularStyle(
                      fontSize: 14,
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
