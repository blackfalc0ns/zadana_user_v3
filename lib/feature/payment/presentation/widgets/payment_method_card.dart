import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class PaymentMethodCard extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const PaymentMethodCard({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

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
          
          // Credit/Debit Card
          _buildPaymentOption(
            context,
            'card',
            l10n.credit_debit_card,
            Icons.credit_card,
            l10n.credit_card_subtitle,
          ),
          
          // Apple Pay
          _buildPaymentOption(
            context,
            'apple_pay',
            l10n.apple_pay,
            Icons.apple,
            l10n.apple_pay_subtitle,
          ),
          
          // Cash on Delivery
          _buildPaymentOption(
            context,
            'cash',
            l10n.cash_on_delivery,
            Icons.money,
            l10n.cash_on_delivery_subtitle,
          ),
          
          // Bank Transfer
          _buildPaymentOption(
            context,
            'bank',
            l10n.bank_transfer,
            Icons.account_balance,
            l10n.bank_transfer_subtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = selectedMethod == value;
    final colors = Theme.of(context).colorScheme;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: Spacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Spacing.md),
          onTap: () => onMethodChanged(value),
          child: Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary.withValues(alpha: 0.05) : colors.surface,
              borderRadius: BorderRadius.circular(Spacing.md),
              border: Border.all(
                color: isSelected ? colors.primary : colors.outline.withValues(alpha: 0.5),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Row(
              children: [
                // Icon Container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Spacing.sm + 2),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                
                // Content
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
                  ),
                ),
                
                // Selection Indicator
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
                    ? Icon(
                        Icons.check,
                        color: colors.onPrimary,
                        size: 12,
                      )
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