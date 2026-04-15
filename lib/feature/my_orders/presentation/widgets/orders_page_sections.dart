import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_details_page.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_card.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/orders_empty_state.dart';

class OrdersHeroHeader extends StatelessWidget {
  const OrdersHeroHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: .06),
            colors.secondary.withValues(alpha: .03),
            colors.surface,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(Spacing.xl),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .28)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subtitle,
              style: getRegularStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: .95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.inventory_2_rounded,
              color: colors.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersOverviewRow extends StatelessWidget {
  const OrdersOverviewRow({
    super.key,
    required this.activeCount,
    required this.completedCount,
    required this.returningCount,
  });

  final int activeCount;
  final int completedCount;
  final int returningCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      spacing: Spacing.md,
      // runSpacing: Spacing.md,
      children: [
        Flexible(
          child: _OrdersOverviewChip(
            label: l10n.active_orders_tab,
            count: activeCount,
            icon: Icons.flash_on_rounded,
            accentColor: AppColors.primary,
          ),
        ),
        Flexible(
          child: _OrdersOverviewChip(
            label: l10n.completed_orders_tab,
            count: completedCount,
            icon: Icons.verified_rounded,
            accentColor: AppColors.secondary,
          ),
        ),
        Flexible(
          child: _OrdersOverviewChip(
            label: l10n.returned_orders_tab,
            count: returningCount,
            icon: Icons.restore_outlined,
            accentColor: AppColors.error,
          ),
        ),
      ],
    );
  }
}

class OrdersTabContent extends StatelessWidget {
  const OrdersTabContent({
    super.key,
    required this.orders,
    required this.emptyTitle,
    required this.emptyIcon,
    required this.isCompleted,
  });

  final List<OrderUiModel> orders;
  final String emptyTitle;
  final IconData emptyIcon;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return OrdersEmptyState(title: emptyTitle, icon: emptyIcon);
    }
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
      itemBuilder: (context, index) => OrderCard(
        order: orders[index],
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OrderDetailsPage(order: orders[index]),
            ),
          );
        },
      ),
    );
  }
}

class OrdersErrorState extends StatelessWidget {
  const OrdersErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: getMediumStyle(
          fontSize: FontSize.size15,
          fontFamily: FontConstant.cairo,
          color: colors.onSurface,
        ),
      ),
    );
  }
}

class _OrdersOverviewChip extends StatelessWidget {
  const _OrdersOverviewChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(Spacing.lg),
        border: Border.all(color: accentColor.withValues(alpha: .12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          Column(
            children: [
              Text(
                '$count',
                style: getBoldStyle(
                  fontSize: FontSize.size20,
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurface,
                ),
              ),
              Text(
                label,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
