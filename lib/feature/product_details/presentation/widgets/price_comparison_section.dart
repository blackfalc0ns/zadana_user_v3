import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/product_details/presentation/widgets/store_price_card.dart';

class PriceComparisonSection extends StatelessWidget {
  final double basePrice;
  final double? oldPrice;
  final String currency;

  const PriceComparisonSection({
    super.key,
    required this.basePrice,
    this.oldPrice,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.store_price_comparison,
            style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.base),
          StorePriceCard(
            storeName: 'متجر الأونلاين',
            price: basePrice,
            isAvailable: true,
            currency: currency,
          ),
          const SizedBox(height: Spacing.sm),
          StorePriceCard(
            storeName: 'كارفور',
            price: basePrice + 15,
            isAvailable: true,
            currency: currency,
          ),
          const SizedBox(height: Spacing.sm),
          StorePriceCard(
            storeName: 'بنده',
            price: basePrice + 8,
            isAvailable: true,
            currency: currency,
          ),
          if (oldPrice != null) ...[
            const SizedBox(height: Spacing.sm),
            StorePriceCard(
              storeName: 'علم التغذية',
              price: oldPrice!,
              isAvailable: false,
              currency: currency,
            ),
          ],
        ],
      ),
    );
  }
}
