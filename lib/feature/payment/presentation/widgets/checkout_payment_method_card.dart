import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class CheckoutPaymentMethodCard extends StatelessWidget {
  const CheckoutPaymentMethodCard({
    super.key,
    required this.paymentMethods,
    required this.selectedMethodCode,
    required this.onMethodChanged,
  });

  final List<CheckoutPaymentMethodEntity> paymentMethods;
  final String? selectedMethodCode;
  final ValueChanged<String> onMethodChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.payment_outlined,
            title: l10n.payment_method,
          ),
          const SizedBox(height: Spacing.md),
          for (final method in paymentMethods) ...[
            _PaymentMethodTile(
              method: method,
              isSelected: selectedMethodCode == method.code,
              onTap: method.isAvailable ? () => onMethodChanged(method.code) : null,
            ),
            if (method != paymentMethods.last) const SizedBox(height: Spacing.xs),
          ],
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.isSelected,
    this.onTap,
  });

  final CheckoutPaymentMethodEntity method;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final title = resolvePaymentMethodTitle(l10n, method.code, method.label);
    final subtitle = resolvePaymentMethodSubtitle(l10n, method.code);

    return Opacity(
      opacity: method.isAvailable ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Spacing.md),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.05)
                  : colors.surface,
              borderRadius: BorderRadius.circular(Spacing.md),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : colors.outline.withValues(alpha: 0.18),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary
                        : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Spacing.sm + 2),
                  ),
                  child: Icon(
                    resolvePaymentMethodIcon(method.code),
                    color: isSelected
                        ? colors.onPrimary
                        : colors.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getBoldStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: isSelected
                              ? colors.primary
                              : colors.onSurface.withValues(alpha: 0.85),
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: getRegularStyle(
                            fontSize: FontSize.size11,
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!method.isAvailable)
                  Text(
                    l10n.not_available,
                    style: getMediumStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.error,
                    ),
                  )
                else
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? colors.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? colors.primary : colors.outline,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: colors.onPrimary, size: 12)
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
