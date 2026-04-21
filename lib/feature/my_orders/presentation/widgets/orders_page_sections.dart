import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/my_orders_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/my_orders_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_details_page.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_card.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/orders_loading_widget.dart';

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
      children: [
        Flexible(
          child: OrdersOverviewChip(
            label: l10n.active_orders_tab,
            count: activeCount,
            icon: Icons.flash_on_rounded,
            accentColor: AppColors.primary,
          ),
        ),
        Flexible(
          child: OrdersOverviewChip(
            label: l10n.completed_orders_tab,
            count: completedCount,
            icon: Icons.verified_rounded,
            accentColor: AppColors.secondary,
          ),
        ),
        Flexible(
          child: OrdersOverviewChip(
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
    required this.section,
    required this.emptyTitle,
    required this.emptyIcon,
    required this.onRetry,
    required this.onLoadMore,
  });

  final OrdersTabState section;
  final String emptyTitle;
  final IconData emptyIcon;
  final Future<void> Function() onRetry;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (section.isLoading && section.items.isEmpty) {
      return const OrdersLoadingWidget();
    }

    if (section.failure != null && section.items.isEmpty) {
      return ApiErrorWidget.fromFailure(section.failure!, onRetry: onRetry);
    }

    if (section.items.isEmpty) {
      return EmptyStateWidget(
        title: emptyTitle,
        description: AppLocalizations.of(context)!.my_orders_subtitle,
        icon: emptyIcon,
      );
    }

    return RefreshIndicator(
      onRefresh: onRetry,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical &&
              notification.metrics.extentAfter <= 320) {
            onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: section.items.length + (section.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
          itemBuilder: (context, index) {
            if (index >= section.items.length) {
              return const SizedBox(
                height: 180,
                child: OrdersLoadingWidget(itemCount: 1),
              );
            }

            final order = section.items[index];
            return OrderCard(
              order: order,
              onTap: () async {
                final didDelete = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) =>
                          getIt<OrderDetailsViewModel>()..load(order.id),
                      child: OrderDetailsPage(order: order),
                    ),
                  ),
                );

                if (didDelete == true && context.mounted) {
                  context.read<MyOrdersViewModel>().loadInitial();
                }
              },
            );
          },
        ),
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

class OrdersOverviewChip extends StatelessWidget {
  const OrdersOverviewChip({
    super.key,
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
