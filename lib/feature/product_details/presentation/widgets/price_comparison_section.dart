import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/modern_store_card.dart';
import 'package:zadana_user_v3/feature/product_details/domain/entities/product_vendor_price_entity.dart';

class PriceComparisonSection extends StatelessWidget {
  const PriceComparisonSection({super.key, required this.vendorPrices});

  final List<ProductVendorPriceEntity> vendorPrices;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    if (vendorPrices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.compare_prices,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            color: color.onSurfaceVariant,
            fontSize: FontSize.size15,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 138,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
           
            itemCount: vendorPrices.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final store = vendorPrices[index];

              return SizedBox(
                width: 145,
                child: ModernStoreCard(
                  storeName: store.name,
                  price: store.price,
                  isLowest: false,
                  icon: Icons.store,
                  gradientColors: const [],
                  discountPercentage: 0,
                  isDiscounted: store.isDiscounted,
                  oldPrice: store.oldPrice,
                  storeImage: store.logoUrl,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
