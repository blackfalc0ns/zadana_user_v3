import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/data/fake_orders_data.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/orders_loading_widget.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/orders_page_sections.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/orders_tab_bar.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.surfaceContainerLowest,
        appBar: CustomAppBar(title: l10n.my_orders_title),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.base,
            Spacing.base,
            Spacing.base,
            Spacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OrdersTabBar(),
              const SizedBox(height: Spacing.base),
              Expanded(
                child: FutureBuilder<List<OrderUiModel>>(
                  future: FakeOrdersData.getOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const TabBarView(
                        children: [
                          OrdersLoadingWidget(),
                          OrdersLoadingWidget(),
                          OrdersLoadingWidget(),
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return OrdersErrorState(message: l10n.error_unknown);
                    }
                    final orders = snapshot.data ?? const <OrderUiModel>[];
                    final activeOrders = orders
                        .where((order) => order.status.isActive)
                        .toList();
                    final completedOrders = orders
                        .where((order) => order.status.isCompleted)
                        .toList();
                    final returningOrders = orders
                        .where((order) => order.status.isReturning)
                        .toList();
                    return Column(
                      children: [
                        OrdersOverviewRow(
                          activeCount: activeOrders.length,
                          completedCount: completedOrders.length,
                          returningCount: returningOrders.length,
                        ),
                        const SizedBox(height: Spacing.base),
                        Expanded(
                          child: TabBarView(
                            children: [
                              OrdersTabContent(
                                orders: activeOrders,
                                emptyTitle: l10n.no_active_orders,
                                emptyIcon: Icons.local_shipping_outlined,
                                isCompleted: false,
                              ),
                              OrdersTabContent(
                                orders: completedOrders,
                                emptyTitle: l10n.no_previous_orders,
                                emptyIcon: Icons.receipt_long_outlined,
                                isCompleted: true,
                              ),
                              OrdersTabContent(
                                orders: returningOrders,
                                emptyTitle: l10n.no_returning_orders,
                                emptyIcon: Icons.restore_outlined,
                                isCompleted: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
