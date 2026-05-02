import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';

class OrderSupportCaseDetailsView extends StatelessWidget {
  const OrderSupportCaseDetailsView({
    super.key,
    required this.orderSupportCase,
  });

  final OrderSupportCaseEntity orderSupportCase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final note = orderSupportCase.customerVisibleNote?.trim() ?? '';
    final visibleActivities = orderSupportCase.activities
        .where((activity) => activity.visibleToCustomer)
        .toList(growable: false);

    return Column(
      children: [
        DetailSection(
          title: l10n.my_orders_support_case_details_title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SupportCaseDetailRow(
                label: l10n.my_orders_support_case_reason_label,
                value: _reasonLabel(l10n, orderSupportCase.reasonCode),
                valueColor: colors.primary,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: l10n.my_orders_support_case_queue_label,
                value: _queueLabel(orderSupportCase.queue, locale),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: l10n.my_orders_support_case_priority_label,
                value: _priorityLabel(orderSupportCase.priority, locale),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Divider(height: 1),
              ),
              _SupportCaseDetailRow(
                label: l10n.my_orders_created_at,
                value: _formatDate(orderSupportCase.createdAt, locale),
              ),
              const SizedBox(height: Spacing.base),
              DecoratedBlock(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.my_orders_support_case_sheet_hint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(orderSupportCase.message),
                  ],
                ),
              ),
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
            ],
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
                              activity.title,
                              activity.action,
                            ),
                            note: (activity.note ?? '').trim(),
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

    if (normalizedAction == 'submitted') {
      return l10n.my_orders_support_case_created;
    }
    if (normalizedTitle.isEmpty) {
      return _humanize(action);
    }
    return _humanize(normalizedTitle);
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
                          return const SizedBox(
                            height: 220,
                            child: Center(child: Text('تعذر عرض الصورة')),
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
