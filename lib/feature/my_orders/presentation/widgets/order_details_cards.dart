import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
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

class ComplaintStatusCard extends StatelessWidget {
  const ComplaintStatusCard({
    super.key,
    required this.title,
    required this.message,
    this.attachments = const [],
  });

  final String title;
  final String message;
  final List<PlatformFile> attachments;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconContainer(
            icon: Icons.support_agent_outlined,
            iconColor: colors.secondary,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  SecondaryText(message),
                ],
                if (attachments.isNotEmpty) ...[
                  const SizedBox(height: Spacing.sm),
                  ComplaintAttachmentsPreview(attachments: attachments),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsActions extends StatelessWidget {
  const OrderDetailsActions({
    super.key,
    required this.canCancel,
    required this.canRetryPayment,
    required this.hasComplaint,
    required this.isCancelling,
    required this.isRetryingPayment,
    required this.isComplaintBusy,
    required this.onCancel,
    required this.onRetryPayment,
    required this.onComplaint,
  });

  final bool canCancel;
  final bool canRetryPayment;
  final bool hasComplaint;
  final bool isCancelling;
  final bool isRetryingPayment;
  final bool isComplaintBusy;
  final VoidCallback onCancel;
  final VoidCallback onRetryPayment;
  final VoidCallback onComplaint;

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
            text: hasComplaint
                ? l10n.my_orders_follow_up
                : l10n.my_orders_submit_complaint,
            variant: hasComplaint
                ? AppButtonVariant.outlined
                : AppButtonVariant.filled,
            color: colors.primary,
            height: 50,
            borderRadius: 18,
            fontWeight: FontWeight.w600,
            isLoading: isComplaintBusy,
            onPressed: onComplaint,
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
