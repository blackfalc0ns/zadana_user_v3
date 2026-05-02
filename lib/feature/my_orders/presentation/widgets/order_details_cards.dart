import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_shared.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_status_badge.dart';

class OrderHeaderCard extends StatelessWidget {
  const OrderHeaderCard({
    super.key,
    required this.status,
    required this.date,
    required this.itemCount,
    required this.total,
  });

  final OrderStatus status;
  final String date;
  final int itemCount;
  final String total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SurfaceCard(
      padding: const EdgeInsets.all(Spacing.lg),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.my_orders_created_at}: $date',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              OrderStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: MetaPill(
                  icon: Icons.inventory_2_outlined,
                  label: l10n.my_orders_items_count,
                  value: '$itemCount',
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: MetaPill(
                  icon: Icons.payments_outlined,
                  label: l10n.total,
                  value: total,
                  highlighted: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderSummaryGrid extends StatelessWidget {
  const OrderSummaryGrid({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  final int itemCount;
  final String subtotal;
  final String shipping;
  final String total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SummaryRow(label: l10n.my_orders_piece_count, value: '$itemCount'),
        const SizedBox(height: Spacing.sm),
        SummaryRow(label: l10n.subtotal, value: subtotal),
        const SizedBox(height: Spacing.sm),
        SummaryRow(label: l10n.shipping, value: shipping),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Divider(height: 1),
        ),
        SummaryRow(label: l10n.total, value: total, emphasized: true),
      ],
    );
  }
}

class OrderPaymentSummary extends StatelessWidget {
  const OrderPaymentSummary({
    super.key,
    required this.methodLabel,
    required this.statusLabel,
  });

  final String methodLabel;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        SummaryRow(label: l10n.payment_method, value: methodLabel),
        const SizedBox(height: Spacing.sm),
        SummaryRow(label: l10n.profile_status_label, value: statusLabel),
      ],
    );
  }
}

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({
    super.key,
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;
  final String price;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DecoratedBlock(
      child: Row(
        children: [
          LeadingQuantityBadge(quantity: quantity),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                SecondaryText('${l10n.my_orders_unit_price}: $price'),
              ],
            ),
          ),
          AmountText(price),
        ],
      ),
    );
  }
}

class ActiveSupportCaseCard extends StatelessWidget {
  const ActiveSupportCaseCard({
    super.key,
    required this.title,
    required this.message,
    required this.status,
    required this.typeLabel,
    this.customerVisibleNote,
    this.onTap,
  });

  final String title;
  final String message;
  final OrderSupportCaseStatus status;
  final String typeLabel;
  final String? customerVisibleNote;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final note = customerVisibleNote?.trim() ?? '';
    final normalizedMessage = message.trim();
    final hasMessage = normalizedMessage.isNotEmpty;
    final hasNote = note.isNotEmpty;
    final previewText = hasNote ? note : normalizedMessage;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          IconContainer(
                            icon: Icons.support_agent_outlined,
                            iconColor: colors.secondary,
                            size: 44,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: Spacing.xs,
                        runSpacing: Spacing.xs,
                        children: [
                          SupportCaseStatusBadge(status: status),
                          if (typeLabel.trim().isNotEmpty && typeLabel != title)
                            _SupportCaseMetaChip(
                              label: typeLabel,
                              icon: Icons.label_outline_rounded,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: colors.onSurfaceVariant,
                    size: 28,
                  ),
                ),
              ],
            ),
            if (hasMessage || hasNote) ...[
              const SizedBox(height: Spacing.base),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: .9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SecondaryText(
                  previewText,
                  maxLines: 3,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
            if (hasMessage && hasNote) ...[
              const SizedBox(height: Spacing.sm),
              DecoratedBlock(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.notes_rounded, size: 18, color: colors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SecondaryText(
                        normalizedMessage,
                        maxLines: 3,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SupportCaseMetaChip extends StatelessWidget {
  const _SupportCaseMetaChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SupportCaseStatusBadge extends StatelessWidget {
  const SupportCaseStatusBadge({super.key, required this.status});

  final OrderSupportCaseStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = supportCaseStatusColors(
      Theme.of(context).colorScheme,
      status,
    );
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        supportCaseStatusLabel(l10n, status),
        style: TextStyle(color: colors.$2, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class OrderDetailsActions extends StatelessWidget {
  const OrderDetailsActions({
    super.key,
    required this.canCancel,
    required this.canRetryPayment,
    required this.hasActiveSupportCase,
    required this.isCancelling,
    required this.isRetryingPayment,
    required this.isSupportCaseBusy,
    required this.onCancel,
    required this.onRetryPayment,
    required this.onSupportCase,
  });

  final bool canCancel;
  final bool canRetryPayment;
  final bool hasActiveSupportCase;
  final bool isCancelling;
  final bool isRetryingPayment;
  final bool isSupportCaseBusy;
  final VoidCallback onCancel;
  final VoidCallback onRetryPayment;
  final VoidCallback onSupportCase;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (canCancel)
          Expanded(
            child: AppButton.outlined(
              text: l10n.my_orders_return_request,
              color: AppColors.error,
              textColor: AppColors.error,
              height: 50,
              borderRadius: 18,
              onPressed: onCancel,
              isLoading: isCancelling,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (canCancel) const SizedBox(width: Spacing.sm),
        if (canRetryPayment)
          Expanded(
            child: AppButton.outlined(
              text: l10n.my_orders_retry_payment,
              color: colors.primary,
              textColor: colors.primary,
              height: 50,
              borderRadius: 18,
              onPressed: onRetryPayment,
              isLoading: isRetryingPayment,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (canRetryPayment) const SizedBox(width: Spacing.sm),
        Expanded(
          child: AppButton(
            text: hasActiveSupportCase
                ? l10n.my_orders_support_case_view
                : l10n.my_orders_support_case_action,
            variant: hasActiveSupportCase
                ? AppButtonVariant.outlined
                : AppButtonVariant.filled,
            color: colors.primary,
            height: 50,
            borderRadius: 18,
            fontWeight: FontWeight.w600,
            isLoading: isSupportCaseBusy,
            onPressed: onSupportCase,
          ),
        ),
      ],
    );
  }
}

class MetaPill extends StatelessWidget {
  const MetaPill({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tone = highlighted ? colors.primary : colors.secondary;

    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: highlighted
            ? colors.primary.withValues(alpha: .08)
            : colors.secondary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          IconContainer(
            icon: icon,
            iconColor: tone,
            size: 38,
            iconSize: 18,
            radius: 12,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: LabelValueColumn(
              label: label,
              value: value,
              valueColor: tone,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: emphasized ? colors.onSurface : colors.onSurfaceVariant,
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: emphasized ? colors.primary : colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class LeadingQuantityBadge extends StatelessWidget {
  const LeadingQuantityBadge({super.key, required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        l10n.my_orders_quantity_badge(quantity),
        style: TextStyle(color: colors.primary, fontWeight: FontWeight.w800),
      ),
    );
  }
}
