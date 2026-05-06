import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_sheets.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_support_case_sections.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_formatters.dart';

class OrderSupportCasePage extends StatelessWidget {
  const OrderSupportCasePage({
    super.key,
    required this.orderId,
    this.initialCaseId,
  });

  final String orderId;
  final String? initialCaseId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.my_orders_support_case_title),
      body: BlocConsumer<OrderSupportCaseViewModel, OrderSupportCaseState>(
        listenWhen: (previous, current) =>
            previous.feedbackMessage != current.feedbackMessage,
        listener: (context, state) {
          final feedback = state.feedbackMessage;
          if (feedback == null || feedback.isEmpty) return;
          if (state.isFeedbackError) {
            CustomSnackbar.showError(context: context, message: feedback);
          } else {
            CustomSnackbar.showSuccess(context: context, message: feedback);
          }
          context.read<OrderSupportCaseViewModel>().clearFeedback();
        },
        builder: (context, state) {
          final isInitialLoading =
              (state.isLoading || state.isCaseLoading) &&
              state.selectedCase == null;

          if (isInitialLoading) {
            return const CustomProgressIndicator();
          }

          if (state.failure != null && state.items.isEmpty) {
            return ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () => context.read<OrderSupportCaseViewModel>().refresh(
                initialCaseId: initialCaseId,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<OrderSupportCaseViewModel>().refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Spacing.base),
              children: [
                if (state.isCaseLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Spacing.lg),
                    child: CustomProgressIndicator(size: 56),
                  )
                else if (state.selectedCase != null)
                  Column(
                    children: [
                      _SupportCaseOverviewCard(
                        orderSupportCase: state.selectedCase!,
                      ),
                      const SizedBox(height: Spacing.base),
                      OrderSupportCaseDetailsView(
                        orderSupportCase: state.selectedCase!,
                        isSendingMessage: state.isSendingMessage,
                        onSendMessage: state.selectedCase!.canSendMessage
                            ? () async {
                                final result =
                                    await showOrderSupportMessageSheet(
                                      context: context,
                                    );
                                if (result == null || !context.mounted) return;
                                await context
                                    .read<OrderSupportCaseViewModel>()
                                    .sendMessage(
                                      state.selectedCase!.id,
                                      message: result.message,
                                      attachmentPaths: result.attachments
                                          .map((item) => item.path ?? '')
                                          .toList(growable: false),
                                    );
                              }
                            : null,
                      ),
                    ],
                  )
                else
                  DetailSection(
                    title: l10n.my_orders_support_case_details_title,
                    child: SecondaryText(
                      l10n.my_orders_support_case_empty_details,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SupportCaseOverviewCard extends StatelessWidget {
  const _SupportCaseOverviewCard({required this.orderSupportCase});

  final OrderSupportCaseEntity orderSupportCase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final localizedMessageFallback = orderSupportCase.messages.reversed
        .map(
          (message) => supportCaseSanitizeVisibleText(
            l10n,
            message.displayBody,
            caseId: orderSupportCase.id,
            fieldName: 'messages.body',
          ),
        )
        .firstWhere((message) => message.isNotEmpty, orElse: () => '');
    final localizedActivityNoteFallback = orderSupportCase.activities.reversed
        .where((activity) => activity.visibleToCustomer)
        .map(
          (activity) => supportCaseSanitizeVisibleText(
            l10n,
            activity.displayNote,
            caseId: orderSupportCase.id,
            fieldName: 'activities.note',
          ),
        )
        .firstWhere((note) => note.isNotEmpty, orElse: () => '');
    final operationalTypeLabel = supportCaseOperationalTypeLabel(
      l10n,
      type: orderSupportCase.type,
      status: orderSupportCase.status,
      settlementStatus: orderSupportCase.settlementStatus,
    );
    final mainStatusLabel = supportCaseMainStatusLabel(
      l10n,
      orderSupportCase.status,
    );
    final typeMeta = supportCaseOperationalMetaText(
      l10n,
      caseId: orderSupportCase.id,
      type: orderSupportCase.type,
      status: orderSupportCase.status,
      settlementStatus: orderSupportCase.settlementStatus,
      backendText: localizedMessageFallback.isNotEmpty
          ? localizedMessageFallback
          : (localizedActivityNoteFallback.isNotEmpty
                ? localizedActivityNoteFallback
                : orderSupportCase.message),
      sourceField: 'message',
    );
    final createdAt = _formatDate(orderSupportCase.createdAt, locale);
    final updatedAt = _formatDate(orderSupportCase.updatedAt, locale);

    return SurfaceCard(
      padding: const EdgeInsets.all(Spacing.lg),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      operationalTypeLabel.trim().isEmpty
                          ? l10n.my_orders_support_case_title
                          : operationalTypeLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (typeMeta.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      SecondaryText(typeMeta, maxLines: 2),
                    ],
                    const SizedBox(height: 6),
                    SecondaryText(
                      '${locale == 'ar' ? 'رقم الحالة' : 'Case ID'}: ${orderSupportCase.id}',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              SupportCaseStatusBadge(
                status: orderSupportCase.status,
                label: mainStatusLabel,
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: _OverviewMetaTile(
                  icon: Icons.calendar_today_outlined,
                  label: l10n.my_orders_created_at,
                  value: createdAt,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _OverviewMetaTile(
                  icon: Icons.update_rounded,
                  label: locale == 'ar' ? 'آخر تحديث' : 'Last update',
                  value: updatedAt,
                  accent: colors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime? dateTime, String locale) {
    if (dateTime == null) return '-';
    return DateFormat.yMMMd(locale).add_jm().format(dateTime.toLocal());
  }
}

class _OverviewMetaTile extends StatelessWidget {
  const _OverviewMetaTile({
    required this.icon,
    required this.label,
    required this.value,
    this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tone = accent ?? colors.primary;

    return DecoratedBlock(
      child: Row(
        children: [
          IconContainer(icon: icon, iconColor: tone, size: 38, iconSize: 18),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: LabelValueColumn(
              label: label,
              value: value,
              valueColor: colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
