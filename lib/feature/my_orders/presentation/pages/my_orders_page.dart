import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/my_orders_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/my_orders_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/orders_page_sections.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/orders_tab_bar.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyOrdersViewModel>()..loadInitial(),
      child: const _MyOrdersView(),
    );
  }
}

class _MyOrdersView extends StatelessWidget {
  const _MyOrdersView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
      
        appBar: CustomAppBar(title: l10n.my_orders_title),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.base,
            Spacing.base,
            Spacing.base,
            Spacing.lg,
          ),
          child: BlocBuilder<MyOrdersViewModel, MyOrdersState>(
            builder: (context, state) {
              final viewModel = context.read<MyOrdersViewModel>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OrdersTabBar(),
                  const SizedBox(height: Spacing.base),
                  OrdersOverviewRow(
                    activeCount: state.active.total,
                    completedCount: state.completed.total,
                    returningCount: state.returned.total,
                  ),
                  const SizedBox(height: Spacing.base),
                  Expanded(
                    child: TabBarView(
                      children: [
                        OrdersTabContent(
                          section: state.active,
                          emptyTitle: l10n.no_active_orders,
                          emptyIcon: Icons.local_shipping_outlined,
                          onRetry: () =>
                              viewModel.refreshTab(OrdersTabType.active),
                          onLoadMore: () =>
                              viewModel.loadMore(OrdersTabType.active),
                        ),
                        OrdersTabContent(
                          section: state.completed,
                          emptyTitle: l10n.no_previous_orders,
                          emptyIcon: Icons.receipt_long_outlined,
                          onRetry: () =>
                              viewModel.refreshTab(OrdersTabType.completed),
                          onLoadMore: () =>
                              viewModel.loadMore(OrdersTabType.completed),
                        ),
                        OrdersTabContent(
                          section: state.returned,
                          emptyTitle: l10n.no_returning_orders,
                          emptyIcon: Icons.restore_outlined,
                          onRetry: () =>
                              viewModel.refreshTab(OrdersTabType.returned),
                          onLoadMore: () =>
                              viewModel.loadMore(OrdersTabType.returned),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
