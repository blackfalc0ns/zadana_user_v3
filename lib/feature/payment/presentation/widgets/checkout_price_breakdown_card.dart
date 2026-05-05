import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/formatters/price_formatter.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';

class CheckoutPriceBreakdownCard extends StatelessWidget {
  const CheckoutPriceBreakdownCard({super.key, required this.checkoutSummary});

  final CheckoutSummaryEntity checkoutSummary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final summary = checkoutSummary.summary;
    final shippingBreakdown = checkoutSummary.shippingBreakdown;
    final vatLine = _findLine(shippingBreakdown, _isVatLine);
    final codLine = _findLine(shippingBreakdown, _isCodLine);
    final vatAmount = summary.vatAmount ?? vatLine?.amount;
    final codFee = summary.codFee ?? codLine?.amount;
    final shouldShowVat = (vatAmount ?? 0) > 0;
    final shouldShowCodFee = (codFee ?? 0) > 0;
    final currency = localizePaymentCurrency(l10n, summary.currency);

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
          _PriceRow(
            label: l10n.subtotal,
            value: PriceFormatter.formatPrice(summary.subtotal),
            currency: currency,
          ),
          const SizedBox(height: Spacing.xs),
          _PriceRow(
            label: l10n.shipping,
            value: PriceFormatter.formatPrice(summary.shippingCost),
            currency: currency,
          ),
          const SizedBox(height: Spacing.xs),
          _PriceRow(
            label: l10n.discount,
            value: PriceFormatter.formatPrice(summary.discount),
            currency: currency,
            isDiscount: true,
          ),
          if (shouldShowVat) ...[
            const SizedBox(height: Spacing.xs),
            _PriceRow(
              label: _resolveVatLabel(context, vatLine),
              value: PriceFormatter.formatPrice(vatAmount!),
              currency: currency,
            ),
          ],
          if (shouldShowCodFee) ...[
            const SizedBox(height: Spacing.xs),
            _PriceRow(
              label: _resolveCodLabel(context, codLine),
              value: PriceFormatter.formatPrice(codFee),
              currency: currency,
            ),
          ],
          const SizedBox(height: Spacing.sm),
          Container(
            height: 1,
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: Spacing.sm),
          Container(
            padding: const EdgeInsets.all(Spacing.xs),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: _PriceRow(
              label: l10n.total,
              value: PriceFormatter.formatPrice(summary.total),
              currency: currency,
              isTotal: true,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveVatLabel(
    BuildContext context,
    CheckoutShippingLineEntity? line,
  ) {
    if (line != null) {
      final label = resolveBilingualValue(
        context,
        arabic: line.labelAr,
        english: line.labelEn,
      );
      if (label.isNotEmpty) {
        return label;
      }
    }

    return AppLocalizations.of(context)!.vat;
  }

  String _resolveCodLabel(
    BuildContext context,
    CheckoutShippingLineEntity? line,
  ) {
    if (line != null) {
      final label = resolveBilingualValue(
        context,
        arabic: line.labelAr,
        english: line.labelEn,
      );
      if (label.isNotEmpty) {
        return label;
      }
    }

    return AppLocalizations.of(context)!.cod_fee;
  }

  CheckoutShippingLineEntity? _findLine(
    List<CheckoutShippingLineEntity> lines,
    bool Function(String code) test,
  ) {
    for (final line in lines) {
      if (test(line.code)) {
        return line;
      }
    }
    return null;
  }

  bool _isVatLine(String code) {
    final normalized = code.trim().toLowerCase();
    return normalized == 'vat' || normalized == 'vat_amount';
  }

  bool _isCodLine(String code) {
    final normalized = code.trim().toLowerCase();
    return normalized == 'cod_fee' ||
        normalized == 'cod' ||
        normalized == 'cash_on_delivery_fee';
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    required this.currency,
    this.isDiscount = false,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final String currency;
  final bool isDiscount;
  final bool isTotal;

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
          '${isDiscount ? '-' : ''}$value $currency',
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
