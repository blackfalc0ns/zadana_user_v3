import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/services/notification_payload_resolver.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/my_orders_page.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_details_page.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/manager/notifications_state.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/manager/notifications_view_model.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/pages/notification_gest_screen.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/widgets/notification_list_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getIt<TokenService>().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data?.trim();
        final isGuest = token == null || token.isEmpty;

        if (isGuest) {
          return const NotificationsGuestView();
        }

        return BlocProvider(
          create: (_) => getIt<NotificationsViewModel>()..loadInitial(),
          child: const _NotificationsView(),
        );
      },
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.localization;

    return BlocListener<NotificationsViewModel, NotificationsState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage,
      listener: (context, state) {
        final feedback = state.feedbackMessage;
        if (feedback == null || feedback.isEmpty) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(feedback)));
        context.read<NotificationsViewModel>().clearFeedback();
      },
      child: Scaffold(
        backgroundColor: colors.surfaceContainerLowest,
        appBar: CustomAppBar(
          title: l10n.notifications,
          backgroundColor: colors.surfaceContainerLowest,
          titleColor: colors.onSurface,
          showShadow: false,
          actions: [
            BlocBuilder<NotificationsViewModel, NotificationsState>(
              builder: (context, state) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.items.isNotEmpty)
                      IconButton(
                        onPressed: () => _confirmDeleteAll(context),
                        icon: const Icon(Icons.delete_outline_rounded, size: 20,color: Colors.red,),
                        tooltip: l10n.localeName.startsWith('ar')
                            ? 'حذف الكل'
                            : 'Delete all',
                        splashRadius: 20,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.base,
              0,
              Spacing.base,
              Spacing.base,
            ),
            child: BlocBuilder<NotificationsViewModel, NotificationsState>(
              builder: (context, state) {
                if (state.isLoading && state.items.isEmpty) {
                  return const _NotificationsLoadingView();
                }

                if (state.failure != null && state.items.isEmpty) {
                  return ApiErrorWidget(
                    exception: state.failure!.exception,
                    onRetry: context.read<NotificationsViewModel>().loadInitial,
                  );
                }

                if (state.items.isEmpty) {
                  return _NotificationsEmptyView(
                    title: l10n.notifications_empty_title,
                    description: l10n.notifications_empty_description,
                  );
                }

                return Column(
                  children: [
                    _UnreadSummaryCard(unreadCount: state.unreadCount),
                    const SizedBox(height: Spacing.base),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: context
                            .read<NotificationsViewModel>()
                            .refresh,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.axis == Axis.vertical) {
                              context
                                  .read<NotificationsViewModel>()
                                  .handleScrollExtent(
                                    notification.metrics.extentAfter,
                                  );
                            }
                            return false;
                          },
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                state.items.length +
                                (state.isLoadingMore ? 1 : 0),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: Spacing.sm),
                            itemBuilder: (context, index) {
                              if (index >= state.items.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final notification = state.items[index];
                              return Dismissible(
                                key: ValueKey(notification.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: AlignmentDirectional.centerEnd,
                                  padding: const EdgeInsetsDirectional.only(
                                    end: Spacing.lg,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.error.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: colors.error,
                                  ),
                                ),
                                onDismissed: (_) {
                                  context
                                      .read<NotificationsViewModel>()
                                      .deleteNotification(notification.id);
                                },
                                child: NotificationListItem(
                                  notification: notification,
                                  onTap: () => _handleNotificationTap(
                                    context,
                                    notification,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    AppNotificationEntity notification,
  ) async {
    context.read<NotificationsViewModel>().markAsRead(notification.id);

    final payload = <String, dynamic>{
      if (notification.dataObject != null) ...notification.dataObject!,
      'type': notification.type,
      'referenceId': notification.referenceId,
    };
    final orderId = NotificationPayloadResolver.resolveOrderId(payload);
    final caseId = NotificationPayloadResolver.resolveSupportCaseId(payload);

    if (NotificationPayloadResolver.isSupportCaseType(notification.type) &&
        orderId != null &&
        orderId.isNotEmpty) {
      await Navigator.of(context).pushNamed(
        AppRoutes.orderSupportCase,
        arguments: {'orderId': orderId, 'caseId': caseId},
      );
      return;
    }

    if (NotificationPayloadResolver.isOrderRelatedType(notification.type)) {
      if (orderId != null && orderId.isNotEmpty) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<OrderDetailsViewModel>()..load(orderId),
              child: OrderDetailsPage(orderId: orderId),
            ),
          ),
        );
        return;
      }

      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const MyOrdersPage()));
    }
  }

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final l10n = context.localization;
    final colors = context.colorScheme;
    final isArabic = l10n.localeName.startsWith('ar');

    final confirmed = await DialogueUtils.showCompactConfirmationDialog(
      context: context,
      title: isArabic ? 'حذف جميع الإشعارات' : 'Delete all notifications',
      message: isArabic
          ? 'هل تريد حذف جميع الإشعارات؟ لا يمكن التراجع عن هذا الإجراء.'
          : 'Delete all notifications? This cannot be undone.',
      confirmLabel: isArabic ? 'حذف' : 'Delete',
      cancelLabel: l10n.cancel,
      icon: Icons.delete_outline_rounded,
      accentColor: colors.error,
    );

    if (!confirmed || !context.mounted) return;

    context.read<NotificationsViewModel>().deleteAllNotifications();
  }
}

class _UnreadSummaryCard extends StatelessWidget {
  const _UnreadSummaryCard({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.localization;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(
              l10n.notifications_unread_count(unreadCount),
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsEmptyView extends StatelessWidget {
  const _NotificationsEmptyView({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Lottie.asset(
                'assets/lottie_animation/notification.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: color.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsLoadingView extends StatelessWidget {
  const _NotificationsLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
      itemBuilder: (context, index) {
        return Container(
          height: 98,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
        );
      },
    );
  }
}
