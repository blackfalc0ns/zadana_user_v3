import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_card_parts.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap});

  final OrderUiModel order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.lg),
      child: Container(
        padding: const EdgeInsets.all(Spacing.base),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(Spacing.lg),
          border: Border.all(color: colors.primary.withValues(alpha: .14)),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: colors.secondary.withValues(alpha: .03),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderCardHeader(order: order, l10n: l10n),
            const SizedBox(height: Spacing.sm),
            OrderCardSummary(
              itemsLabel: l10n.my_orders_items,
              itemsValue: '${order.itemsCount} ${l10n.item}',
              totalLabel: l10n.total,
              totalValue:
                  '${order.totalPrice.toStringAsFixed(2)} ${l10n.currency}',
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCardSummary extends StatelessWidget {
  const OrderCardSummary({
    super.key,
    required this.itemsLabel,
    required this.itemsValue,
    required this.totalLabel,
    required this.totalValue,
  });

  final String itemsLabel;
  final String itemsValue;
  final String totalLabel;
  final String totalValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(Spacing.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: SummaryInfo(label: itemsLabel, value: itemsValue),
          ),
          Container(
            width: 1,
            height: 28,
            color: colors.primary.withValues(alpha: .14),
          ),
          Expanded(
            child: SummaryInfo(
              label: totalLabel,
              value: totalValue,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryInfo extends StatelessWidget {
  const SummaryInfo({
    super.key,
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
