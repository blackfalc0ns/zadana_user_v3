import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/widgets/modern_store_card.dart';

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'وفر ${(_getHighestPrice() - _getLowestPrice()).toStringAsFixed(0)} ريال',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: _getStores().length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final store = _getStores()[index];
                return SizedBox(
                  width: 145,
                  child: ModernStoreCard(
                    storeName: store['name'] as String,
                    price: store['new_price'] as double,
                    isLowest: store['isLowest'] as bool,
                    icon: store['icon'] as IconData,
                    gradientColors: store['gradientColors'] as List<Color>,
                    savings: store['savings'] as String?,
                    discountPercentage: store['is_discounted'] as bool &&
                            (store['price'] as double) > (store['new_price'] as double)
                        ? (((store['price'] as double) - (store['new_price'] as double)) /
                            (store['price'] as double) * 100).round()
                        : 0,
                    isDiscounted: store['is_discounted'] as bool,
                    oldPrice: store['is_discounted'] as bool &&
                            (store['price'] as double) > (store['new_price'] as double)
                        ? store['price'] as double
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

  double _getHighestPrice() {
    return _getStores()
        .map((store) => store['price'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  double _getLowestPrice() {
    return _getStores()
        .map((store) => store['price'] as double)
        .reduce((a, b) => a < b ? a : b);
  }

  List<Map<String, dynamic>> _getStores() {
    return [
      {
        'name': 'الأونلاين',
        'price': 28.0,
        'new_price': 25.0,
        'isLowest': true,
        'icon': Icons.language,
        'image': null,
        'gradientColors': [
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.7),
        ],
        'is_discounted': true,
      },
      {
        'name': 'كارفور',
        'price': 32.0,
        'new_price': 32.0,
        'isLowest': false,
        'icon': Icons.store,
        'image': null,
        'gradientColors': [
          AppColors.info,
          AppColors.info.withValues(alpha: 0.7),
        ],
        'is_discounted': false,
      },
      {
        'name': 'بنده',
        'price': 35.0,
        'new_price': 35.0,
        'isLowest': false,
        'icon': Icons.shopping_bag,
        'image': null,
        'gradientColors': [
          AppColors.secondary,
          AppColors.secondary.withValues(alpha: 0.7),
        ],
        'is_discounted': false,
      },
      {
        'name': 'لولو',
        'price': 30.0,
        'new_price': 30.0,
        'isLowest': false,
        'icon': Icons.local_grocery_store,
        'image': null,
        'gradientColors': [
          AppColors.success,
          AppColors.success.withValues(alpha: 0.7),
        ],
        'is_discounted': false,
      },
      {
        'name': 'الدانوب',
        'price': 33.0,
        'new_price': 33.0,
        'isLowest': false,
        'icon': Icons.shopping_cart,
        'image': null,
        'gradientColors': [
          AppColors.warning,
          AppColors.warning.withValues(alpha: 0.7),
        ],
        'is_discounted': false,
      },
      {
        'name': 'العثيم',
        'price': 31.0,
        'new_price': 27.5,
        'isLowest': false,
        'icon': Icons.storefront,
        'image': null,
        'gradientColors': [
          AppColors.error,
          AppColors.error.withValues(alpha: 0.7),
        ],
        'is_discounted': true,
      },
    ];
  }
}
