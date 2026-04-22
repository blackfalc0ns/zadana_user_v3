import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';

class TrackOrderActionsSection extends StatelessWidget {
  const TrackOrderActionsSection({
    super.key,
    required this.orderId,
    required this.tracking,
  });

  final String orderId;
  final OrderTrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (tracking.order.status.isActive)
          AppButton.outlined(
            text: l10n.delivery_get_otp,
            icon: Icons.qr_code_rounded,
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.deliveryOtp,
              arguments: {'orderId': orderId},
            ),
            color: color.primary,
            textColor: color.primary,
          ),
        const SizedBox(height: Spacing.sm),
        AppButton(
          text: l10n.back_to_home,
          icon: Icons.home_outlined,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.mainShell,
            (route) => false,
          ),
          color: color.primary,
          textColor: color.onPrimary,
        ),
      ],
    );
  }
}
