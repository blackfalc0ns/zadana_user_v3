import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(Spacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(Spacing.xl),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: .35),
        ),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: .5),
              colorScheme.primary.withValues(alpha: .2),
            ],
          ),
          borderRadius: BorderRadius.circular(Spacing.lg),
        ),
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: getSemiBoldStyle(
          fontSize: FontSize.size15,
          fontFamily: FontConstant.cairo,
        ),
        unselectedLabelStyle: getMediumStyle(
          fontSize: FontSize.size15,
          fontFamily: FontConstant.cairo,
        ),
        tabs: [
          Tab(text: l10n.active_orders_tab),
          Tab(text: l10n.completed_orders_tab),
        ],
      ),
    );
  }
}
