import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.lg),
        border: Border.all(color: color.outline.withValues(alpha: 0.2)),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.fill,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: color.primary,
          borderRadius: BorderRadius.circular(Spacing.md),
        ),
        labelColor: color.onPrimary,
        unselectedLabelColor: color.onSurfaceVariant,
        labelStyle: getBoldStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
        ),
        unselectedLabelStyle: getMediumStyle(
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
        ),
        tabs: [
          Tab(text: l10n.active_orders_tab),
          Tab(text: l10n.completed_orders_tab),
          Tab(text: l10n.returned_orders_tab),
        ],
      ),
    );
  }
}
