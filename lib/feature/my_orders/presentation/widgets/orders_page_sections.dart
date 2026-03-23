import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
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
            colors.primary.withOpacity(.06),
            colors.secondary.withOpacity(.03),
            colors.surface,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(Spacing.xl),
        border: Border.all(color: colors.outlineVariant.withOpacity(.28)),
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
              color: colors.surface.withOpacity(.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.inventory_2_rounded, color: colors.primary, size: 24),
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
  });

  final int activeCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _OrdersOverviewChip(
            label: l10n.active_orders_tab,
            count: activeCount,
            icon: Icons.flash_on_rounded,
            accentColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: _OrdersOverviewChip(
            label: l10n.completed_orders_tab,
            count: completedCount,
            icon: Icons.verified_rounded,
            accentColor: AppColors.secondary,
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
      itemBuilder: (context, index) =>
          OrderCard(order: orders[index], isCompleted: isCompleted),
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
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(Spacing.lg),
        border: Border.all(color: accentColor.withOpacity(.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: Spacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontSize: FontSize.size12,
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
