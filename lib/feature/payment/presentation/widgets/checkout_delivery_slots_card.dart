import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class CheckoutDeliverySlotsCard extends StatelessWidget {
  const CheckoutDeliverySlotsCard({
    super.key,
    required this.deliverySlots,
    required this.onDeliverySlotSelected,
  });

  final List<CheckoutDeliverySlotEntity> deliverySlots;
  final ValueChanged<String> onDeliverySlotSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.calendar_today_outlined,
            title: l10n.estimated_delivery,
          ),
          const SizedBox(height: Spacing.md),
          for (final slot in deliverySlots) ...[
            _DeliverySlotTile(
              slot: slot,
              onTap: slot.isAvailable
                  ? () => onDeliverySlotSelected(slot.id)
                  : null,
            ),
            if (slot != deliverySlots.last) const SizedBox(height: Spacing.xs),
          ],
          if (deliverySlots.isEmpty)
            Text(
              l10n.not_available,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: colors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _DeliverySlotTile extends StatelessWidget {
  const _DeliverySlotTile({required this.slot, this.onTap});

  final CheckoutDeliverySlotEntity slot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = slot.isSelected;
    final timeLabel = _buildTimeLabel();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.08)
              : colors.surface,
          borderRadius: BorderRadius.circular(Spacing.md),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.outline.withValues(alpha: 0.18),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              slot.isAvailable ? Icons.schedule : Icons.block_outlined,
              color: slot.isAvailable ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.label,
                    style: getBoldStyle(
                      fontSize: FontSize.size13,
                      fontFamily: FontConstant.cairo,
                      color: slot.isAvailable
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeLabel,
                    style: getRegularStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colors.primary, size: 20)
            else if (!slot.isAvailable)
              Icon(Icons.lock_outline, color: colors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  String _buildTimeLabel() {
    final formatter = DateFormat('h:mm a');
    final start = formatter.format(slot.startAt.toLocal());
    final end = formatter.format(slot.endAt.toLocal());
    return '$start - $end';
  }
}
