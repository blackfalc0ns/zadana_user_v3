import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_badge.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

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
                  title: l10n.product_details,
                  backgroundColor: colors.secondary,
                ),
              ),
              InfoBadge(
                text: '3 ${l10n.product}',
                backgroundColor: colors.secondary.withValues(alpha: 0.1),
                textColor: colors.secondary,
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
        ],
      ),
    );
  }
}
