import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_cards.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';

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
    final note = orderSupportCase.customerVisibleNote?.trim() ?? '';
    final decisionNote = orderSupportCase.decisionNotes?.trim() ?? '';
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

    return Column(
      children: [
        DetailSection(
          title: l10n.my_orders_support_case_details_title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SupportCaseDetailRow(
                label: locale == 'ar' ? 'نوع الحالة' : 'Case type',
                value: _displayValue(
                  orderSupportCase.displayType,
                  _typeLabel(l10n, orderSupportCase.type),
                ),
                valueColor: colors.primary,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: l10n.my_orders_support_case_reason_label,
                value: _displayValue(
                  orderSupportCase.displayReason,
                  _reasonLabel(l10n, orderSupportCase.reasonCode),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: l10n.my_orders_support_case_queue_label,
                value: _displayValue(
                  orderSupportCase.displayQueue,
                  _queueLabel(orderSupportCase.queue, locale),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: l10n.my_orders_support_case_priority_label,
                value: _displayValue(
                  orderSupportCase.displayPriority,
                  _priorityLabel(orderSupportCase.priority, locale),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: locale == 'ar' ? 'الحالة' : 'Status',
                value: _displayValue(
                  orderSupportCase.displayStatus,
                  _statusLabel(l10n, orderSupportCase.status, locale),
                ),
              ),
              if (orderSupportCase.type ==
                  OrderSupportCaseType.returnRequest) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                  child: Divider(height: 1),
                ),
                _SupportCaseDetailRow(
                  label: locale == 'ar' ? 'حالة التسوية' : 'Settlement',
                  value: _settlementLabel(
                    locale,
                    orderSupportCase.settlementStatus,
                  ),
                  valueColor: colors.primary,
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: l10n.my_orders_created_at,
                value: _formatDate(orderSupportCase.createdAt, locale),
              ),
              if (orderSupportCase.isWaitingOnCustomer) ...[
                const SizedBox(height: Spacing.base),
                DecoratedBlock(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.pending_actions_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SecondaryText(
                          locale == 'ar'
                              ? 'النظام ينتظر ردك الآن.'
                              : 'The case is waiting for your reply now.',
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
                      locale == 'ar' ? 'تفاصيل الحالة' : 'Case details',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(orderSupportCase.message),
                  ],
                ),
              ),
              if (orderSupportCase.approvedRefundAmount != null) ...[
                const SizedBox(height: Spacing.base),
                DecoratedBlock(
                  child: SummaryRow(
                    label: locale == 'ar'
                        ? 'المبلغ المعتمد'
                        : 'Approved amount',
                    value: orderSupportCase.approvedRefundAmount!
                        .toStringAsFixed(2),
                    emphasized: true,
                  ),
                ),
              ],
              if ((orderSupportCase.couponCode?.trim().isNotEmpty ??
                  false)) ...[
                const SizedBox(height: Spacing.base),
                DecoratedBlock(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SupportCaseDetailRow(
                        label: locale == 'ar' ? 'كود الكوبون' : 'Coupon code',
                        value: orderSupportCase.couponCode!,
                        valueColor: colors.primary,
                      ),
                      if (orderSupportCase.couponExpiresAt != null) ...[
                        const SizedBox(height: Spacing.sm),
                        _SupportCaseDetailRow(
                          label: locale == 'ar' ? 'ينتهي في' : 'Expires at',
                          value: _formatDate(
                            orderSupportCase.couponExpiresAt,
                            locale,
                          ),
                        ),
                      ],
                      const SizedBox(height: Spacing.sm),
                      _SupportCaseDetailRow(
                        label: locale == 'ar' ? 'تم الاستخدام' : 'Redeemed',
                        value: orderSupportCase.couponRedeemed
                            ? (locale == 'ar' ? 'نعم' : 'Yes')
                            : (locale == 'ar' ? 'لا' : 'No'),
                      ),
                      const SizedBox(height: Spacing.sm),
                      AppButton.outlined(
                        text: locale == 'ar' ? 'نسخ الكود' : 'Copy code',
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: orderSupportCase.couponCode!),
                          );
                          if (!context.mounted) return;
                          CustomSnackbar.showSuccess(
                            context: context,
                            message: locale == 'ar'
                                ? 'تم نسخ الكود'
                                : 'Code copied',
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
                        locale == 'ar' ? 'قرار الإدارة' : 'Admin decision',
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
                              : () => _showAttachmentPreview(
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
                  text: locale == 'ar' ? 'إرسال متابعة' : 'Send update',
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
          title: locale == 'ar' ? 'المحادثة' : 'Messages',
          child: visibleMessages.isEmpty
              ? SecondaryText(
                  locale == 'ar'
                      ? 'لا توجد رسائل ظاهرة حتى الآن.'
                      : 'No visible messages yet.',
                )
              : Column(
                  children: visibleMessages
                      .map(
                        (message) => Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: _SupportCaseMessageTile(
                            title: message.displayTitle.trim().isEmpty
                                ? _humanize(message.action)
                                : message.displayTitle,
                            body: message.displayBody,
                            authorRole: message.authorRole,
                            createdAt: _formatDate(message.createdAt, locale),
                            attachments: message.attachments,
                            onAttachmentTap: (attachment) =>
                                _showAttachmentPreview(
                                  context,
                                  attachment.fileName,
                                  attachment.fileUrl,
                                ),
                            locale: locale,
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
                  children: visibleActivities
                      .map(
                        (activity) => Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.sm),
                          child: _SupportCaseTimelineTile(
                            title: _activityTitle(
                              l10n,
                              activity.displayTitle,
                              activity.action,
                            ),
                            note: (activity.displayNote ?? '').trim(),
                            createdAt: _formatDate(activity.createdAt, locale),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
      ],
    );
  }

  String _reasonLabel(AppLocalizations l10n, String reasonCode) {
    switch (reasonCode.trim().toLowerCase()) {
      case 'payment_issue':
        return l10n.my_orders_support_case_reason_payment_issue;
      case 'delivery_delay':
        return l10n.my_orders_support_case_reason_delivery_delay;
      case 'prep_delay':
        return l10n.my_orders_support_case_reason_prep_delay;
      case 'fraud':
        return l10n.my_orders_support_case_reason_fraud;
      case 'fraud_suspicion':
        return l10n.my_orders_support_case_reason_fraud_suspicion;
      default:
        return _humanize(reasonCode);
    }
  }

  String _typeLabel(AppLocalizations l10n, OrderSupportCaseType type) {
    switch (type) {
      case OrderSupportCaseType.complaint:
        return l10n.my_orders_support_case_type_complaint;
      case OrderSupportCaseType.returnRequest:
        return l10n.my_orders_support_case_type_return_request;
      case OrderSupportCaseType.unknown:
        return '-';
    }
  }

  String _statusLabel(
    AppLocalizations l10n,
    OrderSupportCaseStatus status,
    String locale,
  ) {
    switch (status) {
      case OrderSupportCaseStatus.submitted:
        return l10n.my_orders_complaint_received;
      case OrderSupportCaseStatus.inReview:
        return l10n.my_orders_complaint_under_review;
      case OrderSupportCaseStatus.awaitingCustomerEvidence:
        return locale == 'ar'
            ? 'بانتظار أدلة من العميل'
            : 'Awaiting customer evidence';
      case OrderSupportCaseStatus.approved:
        return l10n.my_orders_support_case_status_approved;
      case OrderSupportCaseStatus.rejected:
        return l10n.my_orders_support_case_status_rejected;
      case OrderSupportCaseStatus.resolved:
        return locale == 'ar' ? 'تمت المعالجة' : 'Resolved';
      case OrderSupportCaseStatus.unknown:
        return '-';
    }
  }

  String _priorityLabel(String priority, String locale) {
    switch (priority.trim().toLowerCase()) {
      case 'high':
        return locale == 'ar' ? 'عالية' : 'High';
      case 'medium':
        return locale == 'ar' ? 'متوسطة' : 'Medium';
      case 'low':
        return locale == 'ar' ? 'منخفضة' : 'Low';
      default:
        return _humanize(priority);
    }
  }

  String _queueLabel(String queue, String locale) {
    switch (queue.trim().toLowerCase()) {
      case 'finance':
        return locale == 'ar' ? 'المالية' : 'Finance';
      case 'support':
        return locale == 'ar' ? 'الدعم' : 'Support';
      case 'operations':
        return locale == 'ar' ? 'العمليات' : 'Operations';
      default:
        return _humanize(queue);
    }
  }

  String _activityTitle(AppLocalizations l10n, String title, String action) {
    final normalizedAction = action.trim().toLowerCase();
    final normalizedTitle = title.trim();

    if (normalizedTitle.isEmpty) {
      if (normalizedAction == 'submitted') {
        return l10n.my_orders_support_case_created;
      }
      return _humanize(action);
    }
    return normalizedTitle;
  }

  String _settlementLabel(String locale, OrderSupportSettlementStatus status) {
    final isArabic = locale == 'ar';
    switch (status) {
      case OrderSupportSettlementStatus.pendingReview:
        return isArabic ? 'قيد المراجعة' : 'Pending review';
      case OrderSupportSettlementStatus.cashRefunded:
        return isArabic ? 'تم الاسترجاع النقدي' : 'Cash refunded';
      case OrderSupportSettlementStatus.couponIssued:
        return isArabic ? 'تم إصدار كوبون' : 'Coupon issued';
      case OrderSupportSettlementStatus.couponRedeemed:
        return isArabic ? 'تم استخدام الكوبون' : 'Coupon redeemed';
      case OrderSupportSettlementStatus.rejected:
        return isArabic ? 'تم الرفض' : 'Rejected';
      case OrderSupportSettlementStatus.approved:
        return isArabic ? 'تمت الموافقة' : 'Approved';
      case OrderSupportSettlementStatus.unknown:
        return '-';
    }
  }

  String _humanize(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return '-';

    return normalized
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String _displayValue(String preferred, String fallback) {
    final normalizedPreferred = preferred.trim();
    if (normalizedPreferred.isNotEmpty) return normalizedPreferred;

    final normalizedFallback = fallback.trim();
    if (normalizedFallback.isNotEmpty) return normalizedFallback;

    return '-';
  }

  String _formatDate(DateTime? dateTime, String locale) {
    if (dateTime == null) return '-';
    return DateFormat(
      'dd MMM yyyy, hh:mm a',
      locale,
    ).format(dateTime.toLocal());
  }

  Future<void> _showAttachmentPreview(
    BuildContext context,
    String fileName,
    String fileUrl,
  ) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext).colorScheme;

        return Dialog(
          insetPadding: const EdgeInsets.all(Spacing.base),
          backgroundColor: colors.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.base,
                  Spacing.base,
                  Spacing.sm,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: InteractiveViewer(
                  maxScale: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Spacing.base,
                      0,
                      Spacing.base,
                      Spacing.base,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        fileUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            height: 280,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          final isArabic =
                              Localizations.localeOf(
                                dialogContext,
                              ).languageCode ==
                              'ar';
                          return SizedBox(
                            height: 220,
                            child: Center(
                              child: Text(
                                isArabic
                                    ? 'تعذر عرض الصورة'
                                    : 'Unable to preview image',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SupportCaseDetailRow extends StatelessWidget {
  const _SupportCaseDetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 4,
          child: Text(
            label,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: Spacing.base),
        Flexible(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: valueColor ?? colors.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportCaseTimelineTile extends StatelessWidget {
  const _SupportCaseTimelineTile({
    required this.title,
    required this.note,
    required this.createdAt,
  });

  final String title;
  final String note;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBlock(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 20,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  SecondaryText(note),
                ],
                const SizedBox(height: 4),
                SecondaryText(createdAt),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCaseMessageTile extends StatelessWidget {
  const _SupportCaseMessageTile({
    required this.title,
    required this.body,
    required this.authorRole,
    required this.createdAt,
    required this.attachments,
    required this.onAttachmentTap,
    required this.locale,
  });

  final String title;
  final String body;
  final String authorRole;
  final String createdAt;
  final List<OrderSupportCaseAttachmentEntity> attachments;
  final ValueChanged<OrderSupportCaseAttachmentEntity> onAttachmentTap;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final byCustomer = authorRole.trim().toLowerCase() == 'customer';

    return DecoratedBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: (byCustomer ? colors.primary : colors.secondary)
                      .withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  byCustomer
                      ? Icons.person_outline_rounded
                      : Icons.support_agent,
                  size: 18,
                  color: byCustomer ? colors.primary : colors.secondary,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SecondaryText(
                      byCustomer
                          ? (locale == 'ar' ? 'أنت' : 'You')
                          : (locale == 'ar' ? 'الدعم' : 'Support'),
                    ),
                  ],
                ),
              ),
              SecondaryText(createdAt),
            ],
          ),
          if (body.trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Text(body),
          ],
          if (attachments.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: attachments
                  .map(
                    (attachment) => AttachmentChip(
                      fileName: attachment.fileName,
                      onTap: attachment.fileUrl.trim().isEmpty
                          ? null
                          : () => onAttachmentTap(attachment),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}
