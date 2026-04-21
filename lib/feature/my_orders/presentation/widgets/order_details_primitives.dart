import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_status_badge.dart';

class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getSemiBoldStyle(
              fontSize: 16,
              fontFamily: FontConstant.cairo,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          child,
        ],
      ),
    );
  }
}

class ComplaintAttachmentsPreview extends StatelessWidget {
  const ComplaintAttachmentsPreview({super.key, required this.attachments});

  final List<PlatformFile> attachments;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: attachments
          .map((file) => AttachmentChip(fileName: file.name))
          .toList(),
    );
  }
}

class OrderMiniCard extends StatelessWidget {
  const OrderMiniCard({super.key, required this.status, required this.total});

  final OrderStatus status;
  final String total;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(Spacing.sm),
      backgroundOpacity: .18,
      child: Row(
        children: [
          Expanded(child: OrderStatusBadge(status: status)),
          AmountText(total),
        ],
      ),
    );
  }
}

class BottomSheetScaffold extends StatelessWidget {
  const BottomSheetScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.body,
    required this.secondaryActionLabel,
    required this.primaryActionLabel,
    required this.onSecondaryTap,
    required this.onPrimaryTap,
    this.primaryColor,
  });

  final String title;
  final String subtitle;
  final Widget summary;
  final Widget body;
  final String secondaryActionLabel;
  final String primaryActionLabel;
  final VoidCallback onSecondaryTap;
  final VoidCallback? onPrimaryTap;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.sm,
        Spacing.base,
        MediaQuery.of(context).viewInsets.bottom + Spacing.base,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.outlineVariant.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: Spacing.base),
            Center(
              child: Text(
                title,
                style: getSemiBoldStyle(
                  fontSize: 20,
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Center(child: SecondaryText(subtitle, textAlign: TextAlign.center)),
            const SizedBox(height: Spacing.base),
            summary,
            const SizedBox(height: Spacing.base),
            body,
            const SizedBox(height: Spacing.base),
            Row(
              children: [
                Expanded(
                  child: AppButton.outlined(
                    text: secondaryActionLabel,
                    onPressed: onSecondaryTap,
                    height: 54,
                    borderRadius: 18,
                    color: colors.outline,
                    textColor: colors.onSurface,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: AppButton(
                    text: primaryActionLabel,
                    onPressed: onPrimaryTap,
                    height: 54,
                    borderRadius: 18,
                    color: primaryColor ?? colors.primary,
                    textColor: colors.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SheetTextField extends StatelessWidget {
  const SheetTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 3,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: .22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CancelReasonTile extends StatelessWidget {
  const CancelReasonTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: Spacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? colors.primary
                : colors.outlineVariant.withValues(alpha: .25),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colors.primary : colors.outline,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Spacing.base),
    this.borderRadius = 18,
    this.backgroundOpacity,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundOpacity == null
            ? colors.surface
            : colors.surfaceContainerHighest.withValues(
                alpha: backgroundOpacity!,
              ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .16)),
      ),
      child: child,
    );
  }
}

class DecoratedBlock extends StatelessWidget {
  const DecoratedBlock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class IconContainer extends StatelessWidget {
  const IconContainer({
    super.key,
    required this.icon,
    required this.iconColor,
    this.size = 42,
    this.iconSize = 24,
    this.radius = 14,
  });

  final IconData icon;
  final Color iconColor;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}

class LabelValueColumn extends StatelessWidget {
  const LabelValueColumn({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SecondaryText(label),
        const SizedBox(height: 2),
        Text(
          value,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class SecondaryText extends StatelessWidget {
  const SecondaryText(this.text, {super.key, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class AmountText extends StatelessWidget {
  const AmountText(this.value, {super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: getBoldStyle(
        fontFamily: FontConstant.cairo,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class AttachmentChip extends StatelessWidget {
  const AttachmentChip({super.key, required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_outlined, size: 16, color: colors.secondary),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
