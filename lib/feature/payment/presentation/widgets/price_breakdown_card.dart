import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class PriceBreakdownCard extends StatelessWidget {
  final String subtotal;
  final String shipping;
  final String discount;
  final String total;

  const PriceBreakdownCard({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Spacing.sm),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Text(
                l10n.invoice_details,
                style: getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          PriceRow(label: l10n.subtotal, value: subtotal, currency: l10n.sar),
          const SizedBox(height: Spacing.xs),
          PriceRow(label: l10n.shipping, value: shipping, showCurrency: false),
          const SizedBox(height: Spacing.xs),
          PriceRow(
            label: l10n.discount,
            value: discount,
            isDiscount: true,
            showCurrency: false,
          ),
          const SizedBox(height: Spacing.sm),
          _buildDivider(context),
          const SizedBox(height: Spacing.sm),
          Container(
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: PriceRow(
              label: l10n.total,
              value: total,
              currency: l10n.sar,
              isTotal: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.outlineVariant.withValues(alpha: 0.3),
            colors.outlineVariant,
            colors.outlineVariant.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final String? currency;
  final bool isTotal;
  final bool isDiscount;
  final bool showCurrency;

  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.currency,
    this.isTotal = false,
    this.isDiscount = false,
    this.showCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? getBoldStyle(
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurface,
                )
              : getRegularStyle(
                  fontSize: FontSize.size13,
                  fontFamily: FontConstant.cairo,
                  color: colors.onSurfaceVariant,
                ),
        ),
        Text(
          showCurrency && currency != null ? '$value $currency' : value,
          style: isTotal
              ? getBoldStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: colors.primary,
                )
              : getRegularStyle(
                  fontSize: FontSize.size13,
                  fontFamily: FontConstant.cairo,
                  color: isDiscount ? colors.secondary : colors.onSurface,
                ),
        ),
      ],
    );
  }
}

