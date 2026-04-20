import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/modern_store_card.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

class PriceComparisonSection extends StatelessWidget {
  const PriceComparisonSection({
    super.key,
    required this.vendorPrices,
  });

  final List<ProductVendorPriceEntity> vendorPrices;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final stores = _getStores(context);
    if (stores.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_down,
                  color: color.onPrimaryContainer,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.localization.compare_prices,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 138,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: stores.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final store = stores[index];
                final originalPrice = store.oldPrice;
                final salePrice = store.price;
                final hasDiscount =
                    store.isDiscounted &&
                    originalPrice != null &&
                    originalPrice > salePrice;

                return SizedBox(
                  width: 145,
                  child: ModernStoreCard(
                    storeName: store.name,
                    price: salePrice,
                    isLowest: false,
                    icon: Icons.store,
                    gradientColors: const [],
                    discountPercentage: hasDiscount
                        ? (((originalPrice - salePrice) / originalPrice) * 100)
                              .round()
                        : 0,
                    isDiscounted: hasDiscount,
                    oldPrice: hasDiscount ? originalPrice : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ProductVendorPriceEntity> _getStores(BuildContext context) {
    return vendorPrices;
  }
}
