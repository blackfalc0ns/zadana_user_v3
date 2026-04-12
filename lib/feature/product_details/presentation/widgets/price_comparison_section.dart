import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/modern_store_card.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

class PriceComparisonSection extends StatelessWidget {
  final double basePrice;
  final double? oldPrice;
  final String currency;
  final List<ProductVendorPriceEntity> vendorPrices;

  const PriceComparisonSection({
    super.key,
    required this.basePrice,
    this.oldPrice,
    required this.currency,
    required this.vendorPrices,
  });

  @override
  Widget build(BuildContext context) {
    final stores = _getStores();
    if (stores.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_down,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'اسعار المنتج فى المتاجر',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: stores.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final store = stores[index];
                final originalPrice = store['price'] as double;
                final salePrice = store['new_price'] as double;
                final isDiscounted = store['is_discounted'] as bool;

                return SizedBox(
                  width: 145,
                  child: ModernStoreCard(
                    storeName: store['name'] as String,
                    price: salePrice,
                    isLowest: store['isLowest'] as bool,
                    icon: store['icon'] as IconData,
                    gradientColors: store['gradientColors'] as List<Color>,
                    savings: store['savings'] as String?,
                    discountPercentage:
                        isDiscounted && originalPrice > salePrice
                        ? (((originalPrice - salePrice) / originalPrice) * 100)
                              .round()
                        : 0,
                    isDiscounted: isDiscounted,
                    oldPrice: isDiscounted && originalPrice > salePrice
                        ? originalPrice
                        : null,
                    storeImage: store['image'] as String?,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getStores() {
    if (vendorPrices.isEmpty) {
      final effectiveOldPrice = (oldPrice != null && oldPrice! > basePrice)
          ? oldPrice!
          : basePrice;

      return [
        {
          'name': 'المتجر الحالي',
          'price': effectiveOldPrice,
          'new_price': basePrice,
          'isLowest': true,
          'icon': Icons.store,
          'image': null,
          'gradientColors': [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.7),
          ],
          'savings': null,
          'is_discounted': oldPrice != null && oldPrice! > basePrice,
        },
      ];
    }

    final lowestPrice = vendorPrices
        .map((vendor) => vendor.price)
        .reduce((a, b) => a < b ? a : b);

    return vendorPrices.map((vendor) {
      final originalPrice =
          (vendor.oldPrice != null && vendor.oldPrice! > vendor.price)
          ? vendor.oldPrice!
          : vendor.price;

      return {
        'name': vendor.name,
        'price': originalPrice,
        'new_price': vendor.price,
        'isLowest': vendor.price == lowestPrice,
        'icon': Icons.store,
        'image': null,
        'gradientColors': [
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.7),
        ],
        'savings': null,
        'is_discounted':
            vendor.isDiscounted &&
            vendor.oldPrice != null &&
            vendor.oldPrice! > vendor.price,
      };
    }).toList();
  }
}
