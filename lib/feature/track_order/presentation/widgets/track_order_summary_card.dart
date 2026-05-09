import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: color.surface,
        border: Border.all(color: color.outlineVariant.withValues(alpha: .16)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: OrderStatusBadge(status: tracking.order.status),
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   width: 48,
                  //   height: 48,
                  //   decoration: BoxDecoration(
                  //     color: color.primary.withValues(alpha: .10),
                  //     borderRadius: BorderRadius.circular(14),
                  //   ),
                  //   child: Icon(
                  //     Icons.local_shipping_outlined,
                  //     color: color.primary,
                  //     size: 22,
                  //   ),
                  // ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.estimated_delivery,
                          textAlign: TextAlign.end,
                          style: getMediumStyle(
                            fontSize: FontSize.size13,
                            fontFamily: FontConstant.cairo,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          estimatedDeliveryText,
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontSize: FontSize.size18,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.order_number,
                            textAlign: TextAlign.end,
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tracking.order.displayNumber,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getSemiBoldStyle(
                              fontSize: FontSize.size14,
                              fontFamily: FontConstant.cairo,
                              color: color.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
