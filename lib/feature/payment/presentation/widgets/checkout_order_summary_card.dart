import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_badge.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class CheckoutOrderSummaryCard extends StatelessWidget {
  const CheckoutOrderSummaryCard({
    super.key,
    required this.cart,
    required this.currencyCode,
  });

  final CheckoutCartEntity cart;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final currency = localizePaymentCurrency(l10n, currencyCode);

    return InfoCardContainer(
      borderColor: colors.primary.withValues(alpha: 0.08),
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SectionHeader(
                  icon: Icons.shopping_bag_outlined,
                  title: l10n.invoice_details,
                  backgroundColor: colors.secondary,
                ),
              ),
              InfoBadge(
                text: '${cart.itemsCount} ${l10n.product}',
                backgroundColor: colors.secondary.withValues(alpha: 0.1),
                textColor: colors.secondary,
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          for (final item in cart.items) ...[
            _OrderItemTile(item: item, currency: currency),
            if (item != cart.items.last) const SizedBox(height: Spacing.xs),
          ],
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item, required this.currency});

  final CheckoutCartItemEntity item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.xs + 2),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(color: colors.primary.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(Spacing.xs + 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Spacing.xs + 2),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.shopping_bag_outlined,
                        color: colors.onSurfaceVariant,
                        size: 18,
                      ),
                    )
                  : Icon(
                      Icons.shopping_bag_outlined,
                      color: colors.onSurfaceVariant,
                      size: 18,
                    ),
            ),
          ),
          const SizedBox(width: Spacing.xs + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs + 2,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${item.quantity}x',
                        style: getMediumStyle(
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                          color: colors.secondary,
                        ),
                      ),
                    ),
                    if (item.unit != null && item.unit!.isNotEmpty) ...[
                      const SizedBox(width: Spacing.xs),
                      Text(
                        item.unit!,
                        style: getRegularStyle(
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(Spacing.xs + 2),
            ),
            child: Text(
              '${PriceFormatter.formatPrice(item.totalPrice)} $currency',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
