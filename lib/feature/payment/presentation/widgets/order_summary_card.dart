import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_badge.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    
    return InfoCardContainer(
      borderColor: colors.primary.withValues(alpha: 0.08),
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SectionHeader(
                  icon: Icons.shopping_bag_outlined,
                  title: l10n.product_details,
                  backgroundColor: colors.secondary,
                ),
              ),
              InfoBadge(
                text: '3 ${l10n.product}',
                backgroundColor: colors.secondary.withValues(alpha: 0.1),
                textColor: colors.secondary,
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          
          // Sample order items
          _buildOrderItem(
            'خضروات طازجة مشكلة',
            '2x',
            '45.00',
            'assets/images/Cabbage.png',
          ),
          const SizedBox(height: Spacing.xs),
          _buildOrderItem(
            'فلفل حار أحمر',
            '1x',
            '25.50',
            'assets/images/Chilli.png',
          ),
          const SizedBox(height: Spacing.xs),
          _buildOrderItem(
            'منتجات عضوية متنوعة',
            '1x',
            '55.00',
            'assets/images/Cabbage.png',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String quantity, String price, String imagePath) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final colors = Theme.of(context).colorScheme;
        
        return Container(
          padding: const EdgeInsets.all(Spacing.xs + 2),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(Spacing.sm),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Spacing.xs + 2),
                  color: colors.surfaceContainerHighest,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.xs + 2),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: colors.surfaceContainerHighest,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: colors.onSurfaceVariant,
                          size: 18,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: Spacing.xs + 2),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: getMediumStyle(
                        fontSize: FontSize.size12,
                        fontFamily: FontConstant.cairo,
                        color: colors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs + 2,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        quantity,
                        style: getMediumStyle(
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                          color: colors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Price
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(Spacing.xs + 2),
                ),
                child: Text(
                  '$price ${l10n.sar}',
                  style: getBoldStyle(
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}