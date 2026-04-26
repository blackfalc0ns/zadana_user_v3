import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_status_badge.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';

class TrackOrderSummaryCard extends StatelessWidget {
  const TrackOrderSummaryCard({
    super.key,
    required this.tracking,
    required this.estimatedDeliveryText,
  });

  final OrderTrackingEntity tracking;
  final String estimatedDeliveryText;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return SurfaceCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: color.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.estimated_delivery,
                      textAlign: TextAlign.end,
                      style: getMediumStyle(
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      estimatedDeliveryText,
                      textAlign: TextAlign.end,
                      style: getBoldStyle(
                        fontSize: FontSize.size22,
                        fontFamily: FontConstant.cairo,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              OrderStatusBadge(status: tracking.order.status),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: color.surfaceContainerHighest.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${l10n.order_number}: ${tracking.order.id}',
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
