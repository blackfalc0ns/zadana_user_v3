import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_attachment_preview.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_detail_row.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_formatters.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_message_tile.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_timeline_tile.dart';

class OrderSupportCaseDetailsView extends StatelessWidget {
  const OrderSupportCaseDetailsView({
    super.key,
    required this.orderSupportCase,
    this.onSendMessage,
    this.isSendingMessage = false,
  });

  final OrderSupportCaseEntity orderSupportCase;
  final VoidCallback? onSendMessage;
  final bool isSendingMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final mainStatusLabel = supportCaseMainStatusLabel(
      l10n,
      orderSupportCase.status,
    );
    final operationalTypeLabel = supportCaseOperationalTypeLabel(
      l10n,
      type: orderSupportCase.type,
      status: orderSupportCase.status,
      settlementStatus: orderSupportCase.settlementStatus,
    );
    final showWaitingBadge = supportCaseShouldShowWaitingBadge(
      status: orderSupportCase.status,
      waitingOnRole: orderSupportCase.waitingOnRole,
    );
    final note = supportCaseSanitizeVisibleText(
      l10n,
      orderSupportCase.customerVisibleNote,
      caseId: orderSupportCase.id,
      fieldName: 'customerVisibleNote',
    );
    final decisionNote = supportCaseSanitizeVisibleText(
      l10n,
      orderSupportCase.decisionNotes,
      caseId: orderSupportCase.id,
      fieldName: 'decisionNotes',
    );
    final caseBody = supportCaseSanitizeVisibleText(
      l10n,
      orderSupportCase.message,
      caseId: orderSupportCase.id,
      fieldName: 'message',
    );
    final visibleActivities = orderSupportCase.activities
        .where((activity) => activity.visibleToCustomer)
        .toList(growable: false);
    final visibleMessages =
        orderSupportCase.messages
            .where((message) => message.isVisibleToCustomer)
            .toList(growable: false)
          ..sort((a, b) {
            final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return left.compareTo(right);
          });
    final localizedMessageFallback = visibleMessages.reversed
        .map(
          (message) => supportCaseSanitizeVisibleText(
            l10n,
            message.displayBody,
            caseId: orderSupportCase.id,
            fieldName: 'messages.body',
          ),
        )
        .firstWhere((message) => message.isNotEmpty, orElse: () => '');
    final localizedActivityNoteFallback = visibleActivities.reversed
        .map(
          (activity) => supportCaseSanitizeVisibleText(
            l10n,
            activity.displayNote,
            caseId: orderSupportCase.id,
            fieldName: 'activities.note',
          ),
        )
        .firstWhere((note) => note.isNotEmpty, orElse: () => '');
    final resolvedCaseBody = caseBody.isNotEmpty
        ? caseBody
        : (localizedMessageFallback.isNotEmpty
              ? localizedMessageFallback
              : localizedActivityNoteFallback);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DetailSection(
          title: l10n.my_orders_support_case_details_title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SupportCaseDetailRow(
                label: l10n.my_orders_support_case_type_label,
                value: operationalTypeLabel,
                valueColor: colors.primary,
              ),
              const _SupportCaseDivider(),
              SupportCaseDetailRow(
                label: l10n.my_orders_support_case_reason_label,
                value: supportCaseDisplayValue(
                  orderSupportCase.displayReason,
                  supportCaseReasonFallbackLabel(
                    l10n,
                    orderSupportCase.reasonCode,
                  ),
                ),
              ),
              const _SupportCaseDivider(),
              SupportCaseDetailRow(
                label: l10n.my_orders_support_case_queue_label,
                value: supportCaseDisplayValue(
                  orderSupportCase.displayQueue,
                  supportCaseQueueFallbackLabel(l10n, orderSupportCase.queue),
                ),
              ),
              const _SupportCaseDivider(),
              SupportCaseDetailRow(
                label: l10n.my_orders_support_case_priority_label,
                value: supportCaseDisplayValue(
                  orderSupportCase.displayPriority,
                  supportCasePriorityFallbackLabel(
                    l10n,
                    orderSupportCase.priority,
                  ),
                ),
              ),
              const _SupportCaseDivider(),
              SupportCaseDetailRow(
                label: l10n.my_orders_support_case_status_label,
                value: mainStatusLabel,
              ),
              if (orderSupportCase.type == OrderSupportCaseType.returnRequest &&
                  orderSupportCase.settlementStatus !=
                      OrderSupportSettlementStatus.unknown) ...[
                const _SupportCaseDivider(),
                SupportCaseDetailRow(
                  label: l10n.my_orders_support_case_settlement_label,
                  value: supportCaseSettlementLabel(
                    l10n,
                    orderSupportCase.settlementStatus,
                  ),
                  valueColor: colors.primary,
                ),
              ],
              const _SupportCaseDivider(),
              SupportCaseDetailRow(
                label: l10n.my_orders_created_at,
                value: formatSupportCaseDate(
                  orderSupportCase.createdAt,
                  locale,
                ),
              ),
              if (showWaitingBadge) ...[
                const SizedBox(height: Spacing.base),
                DecoratedBlock(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.pending_actions_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SecondaryText(
                          supportCaseWaitingOnLabel(
                            l10n,
                            orderSupportCase.waitingOnRole,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: Spacing.base),
              DecoratedBlock(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.my_orders_support_case_case_details_label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(resolvedCaseBody.isEmpty ? '-' : resolvedCaseBody),
                  ],
                ),
              ),
              if (orderSupportCase.approvedRefundAmount != null) ...[
                const SizedBox(height: Spacing.base),
                DecoratedBlock(
                  child: SummaryRow(
                    label: l10n.my_orders_support_case_approved_amount_label,
                    value: orderSupportCase.approvedRefundAmount!
                        .toStringAsFixed(2),
                    emphasized: true,
                  ),
                ),
              ],
              if ((orderSupportCase.couponCode?.trim().isNotEmpty ??
                  false)) ...[
                const SizedBox(height: Spacing.base),
                _SupportCaseCouponSection(
                  orderSupportCase: orderSupportCase,
                  locale: locale,
                ),
              ],
              if (note.isNotEmpty) ...[
                const SizedBox(height: Spacing.base),
                DecoratedBlock(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: SecondaryText(note)),
                    ],
                  ),
                ),
              ],
              if (decisionNote.isNotEmpty) ...[
                const SizedBox(height: Spacing.base),
                DecoratedBlock(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.my_orders_support_case_admin_decision_label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(decisionNote),
                    ],
                  ),
                ),
              ],
              if (orderSupportCase.status ==
                  OrderSupportCaseStatus.awaitingCustomerEvidence) ...[
                const SizedBox(height: Spacing.sm),
                SecondaryText(l10n.my_orders_support_case_evidence_guidance),
              ],
              if (orderSupportCase.attachments.isNotEmpty) ...[
                const SizedBox(height: Spacing.base),
                Text(
                  l10n.my_orders_support_case_sheet_attach_files,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: Spacing.xs),
                Wrap(
                  spacing: Spacing.xs,
                  runSpacing: Spacing.xs,
                  children: orderSupportCase.attachments
                      .map(
                        (file) => AttachmentChip(
                          fileName: file.fileName,
                          onTap: file.fileUrl.trim().isEmpty
                              ? null
                              : () => showSupportCaseAttachmentPreview(
                                  context,
                                  file.fileName,
                                  file.fileUrl,
                                ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              if (onSendMessage != null) ...[
                const SizedBox(height: Spacing.base),
                AppButton(
                  text: l10n.my_orders_support_case_send_update,
                  onPressed: isSendingMessage ? null : onSendMessage,
                  height: 46,
                  borderRadius: 14,
                  color: colors.primary,
                  textColor: colors.onPrimary,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: Spacing.base),
        DetailSection(
          title: l10n.my_orders_support_case_messages_title,
          child: visibleMessages.isEmpty
              ? SecondaryText(l10n.my_orders_support_case_messages_empty)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: visibleMessages
                      .map(
                        (message) => Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: SupportCaseMessageTile(
                            title:
                                supportCaseSanitizeVisibleText(
                                  l10n,
                                  message.displayTitle,
                                  caseId: orderSupportCase.id,
                                  fieldName: 'messages.title',
                                ).trim().isEmpty
                                ? supportCaseHumanize(message.action)
                                : supportCaseSanitizeVisibleText(
                                    l10n,
                                    message.displayTitle,
                                    caseId: orderSupportCase.id,
                                    fieldName: 'messages.title',
                                  ),
                            body: supportCaseSanitizeVisibleText(
                              l10n,
                              message.displayBody,
                              caseId: orderSupportCase.id,
                              fieldName: 'messages.body',
                            ),
                            authorRole: message.authorRole,
                            createdAt: formatSupportCaseDate(
                              message.createdAt,
                              locale,
                            ),
                            attachments: message.attachments,
                            onAttachmentTap: (attachment) =>
                                showSupportCaseAttachmentPreview(
                                  context,
                                  attachment.fileName,
                                  attachment.fileUrl,
                                ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
        const SizedBox(height: Spacing.base),
        DetailSection(
          title: l10n.my_orders_support_case_timeline_title,
          child: visibleActivities.isEmpty
              ? SecondaryText(l10n.my_orders_support_case_empty_details)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: visibleActivities
                      .map(
                        (activity) => Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: SupportCaseTimelineTile(
                            title: supportCaseActivityTitle(
                              l10n,
                              title: supportCaseSanitizeVisibleText(
                                l10n,
                                activity.displayTitle,
                                caseId: orderSupportCase.id,
                                fieldName: 'activities.title',
                              ),
                              action: activity.action,
                            ),
                            note: supportCaseSanitizeVisibleText(
                              l10n,
                              activity.displayNote,
                              caseId: orderSupportCase.id,
                              fieldName: 'activities.note',
                            ),
                            createdAt: formatSupportCaseDate(
                              activity.createdAt,
                              locale,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
      ],
    );
  }
}

class _SupportCaseDivider extends StatelessWidget {
  const _SupportCaseDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Divider(height: 1),
    );
  }
}

class _SupportCaseCouponSection extends StatelessWidget {
  const _SupportCaseCouponSection({
    required this.orderSupportCase,
    required this.locale,
  });

  final OrderSupportCaseEntity orderSupportCase;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return DecoratedBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupportCaseDetailRow(
            label: l10n.my_orders_support_case_coupon_code_label,
            value: orderSupportCase.couponCode!,
            valueColor: colors.primary,
          ),
          if (orderSupportCase.couponExpiresAt != null) ...[
            const SizedBox(height: Spacing.sm),
            SupportCaseDetailRow(
              label: l10n.my_orders_support_case_expires_at_label,
              value: formatSupportCaseDate(
                orderSupportCase.couponExpiresAt,
                locale,
              ),
            ),
          ],
          const SizedBox(height: Spacing.sm),
          SupportCaseDetailRow(
            label: l10n.my_orders_support_case_redeemed_label,
            value: orderSupportCase.couponRedeemed ? l10n.yes : l10n.no,
          ),
          const SizedBox(height: Spacing.sm),
          AppButton.outlined(
            text: l10n.my_orders_support_case_copy_code,
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: orderSupportCase.couponCode!),
              );
              if (!context.mounted) return;
              CustomSnackbar.showSuccess(
                context: context,
                message: l10n.my_orders_support_case_code_copied,
              );
            },
            height: 42,
            borderRadius: 14,
            color: colors.primary,
            textColor: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
