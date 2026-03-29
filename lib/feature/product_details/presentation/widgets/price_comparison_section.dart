import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

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
          // عنوان مقارنة الأسعار مع تصميم مودرن
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
              Spacer(),
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

          // مربعات المتاجر مع تصميم كريتيف
          SizedBox(
            height: 80, // زيادة من 70 إلى 80
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: _getStores().length,
              separatorBuilder: (_, index) =>
                  const SizedBox(width: 8), // تقليل من 8 إلى 4
              itemBuilder: (_, index) {
                final store = _getStores()[index];
                return SizedBox(
                  width: 125,
                  child: _buildModernStoreCard(
                    storeName: store['name'] as String,
                    price: store['price'] as double,
                    isLowest: store['isLowest'] as bool,
                    icon: store['icon'] as IconData,
                    gradientColors: store['gradientColors'] as List<Color>,
                    savings: store['savings'] as String?,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getLowestPrice() {
    return _getStores()
        .map((store) => store['price'] as double)
        .reduce((a, b) => a < b ? a : b);
  }

  double _getHighestPrice() {
    return _getStores()
        .map((store) => store['price'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  List<Map<String, dynamic>> _getStores() {
    return [
      {
        'name': 'الأونلاين',
        'price': 28.0,
        'isLowest': true,
        'icon': Icons.language,
        'gradientColors': [
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.7),
        ],
        'savings': null,
      },
      {
        'name': 'كارفور',
        'price': 32.0,
        'isLowest': false,
        'icon': Icons.store,
        'gradientColors': [
          AppColors.info,
          AppColors.info.withValues(alpha: 0.7),
        ],
        'savings': '4 ريال',
      },
      {
        'name': 'بنده',
        'price': 35.0,
        'isLowest': false,
        'icon': Icons.shopping_bag,
        'gradientColors': [
          AppColors.secondary,
          AppColors.secondary.withValues(alpha: 0.7),
        ],
        'savings': '7 ريال',
      },
      {
        'name': 'لولو',
        'price': 30.0,
        'isLowest': false,
        'icon': Icons.local_grocery_store,
        'gradientColors': [
          AppColors.success,
          AppColors.success.withValues(alpha: 0.7),
        ],
        'savings': '2 ريال',
      },
      {
        'name': 'الدانوب',
        'price': 33.0,
        'isLowest': false,
        'icon': Icons.shopping_cart,
        'gradientColors': [
          AppColors.warning,
          AppColors.warning.withValues(alpha: 0.7),
        ],
        'savings': '5 ريال',
      },
      {
        'name': 'العثيم',
        'price': 31.0,
        'isLowest': false,
        'icon': Icons.storefront,
        'gradientColors': [
          AppColors.error,
          AppColors.error.withValues(alpha: 0.7),
        ],
        'savings': '3 ريال',
      },
    ];
  }

  Widget _buildModernStoreCard({
    required String storeName,
    required double price,
    required bool isLowest,
    required IconData icon,
    required List<Color> gradientColors,
    required String? savings,
  }) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8), // زيادة من 6 إلى 8
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة في الأعلى
            Container(
              width: 32, // تقليل من 40 إلى 32
              height: 32, // تقليل من 40 إلى 32
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.1),
                    AppColors.secondary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10), // تقليل من 12 إلى 10
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.secondary,
                size: 16, // تقليل من 20 إلى 16
              ),
            ),

            const SizedBox(height: 4), // زيادة من 3 إلى 4
            // اسم المتجر والسعر في نفس الصف
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    storeName,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight:
                          FontWeight.w700, // زيادة الوزن من bold إلى w700
                      color: AppColors.textPrimary,
                      fontSize: 12, // تكبير من 11 إلى 12
                      height: 1.2, // إضافة line height للوضوح
                      letterSpacing: 0.2, // إضافة letter spacing للوضوح
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6), // زيادة من 4 إلى 6
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price.toStringAsFixed(0),
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800, // زيادة الوزن
                          fontSize: 14, // تكبير من 13 إلى 14
                        ),
                      ),
                      const SizedBox(width: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Text(
                          'ريال',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 9, // تكبير من 8 إلى 9
                            fontWeight: FontWeight.w600, // إضافة وزن للوضوح
                          ),
                        ),
                      ),
                    ],
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
