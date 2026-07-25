import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_config_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class CheckoutFulfillmentTypeCard extends StatelessWidget {
  const CheckoutFulfillmentTypeCard({
    super.key,
    this.checkoutConfig,
    required this.selectedFulfillmentType,
    required this.onChanged,
    this.isRefreshing = false,
  });

  final CheckoutConfigEntity? checkoutConfig;
  final String selectedFulfillmentType;
  final ValueChanged<String> onChanged;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isPickup = isPickupFulfillmentType(selectedFulfillmentType);
    final isArabic = isArabicPaymentLocale(context);
    final showDelivery = checkoutConfig?.deliveryEnabled ?? true;
    final showPickup = checkoutConfig?.pickupEnabled ?? true;

    if (!showDelivery && !showPickup) {
      return const SizedBox.shrink();
    }

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.swap_horiz_rounded,
            title: isArabic ? 'طريقة الاستلام' : 'Fulfillment',
            backgroundColor: colors.primary,
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              if (showDelivery)
                Expanded(
                  child: _FulfillmentOptionTile(
                    label: isArabic ? 'التوصيل' : 'Delivery',
                    subtitle: isArabic
                        ? 'المندوب يوصلك الطلب'
                        : 'Delivered by courier',
                    icon: Icons.local_shipping_outlined,
                    isSelected: !isPickup,
                    isDisabled: isRefreshing,
                    onTap: () => onChanged('delivery'),
                  ),
                ),
              if (showDelivery && showPickup) const SizedBox(width: Spacing.sm),
              if (showPickup)
                Expanded(
                  child: _FulfillmentOptionTile(
                    label: isArabic ? 'استلام من الفرع' : 'Pickup',
                    subtitle: isArabic
                        ? 'تستلم الطلب من المطعم'
                        : 'Collect from restaurant',
                    icon: Icons.storefront_outlined,
                    isSelected: isPickup,
                    isDisabled: isRefreshing,
                    onTap: () => onChanged('pickup'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FulfillmentOptionTile extends StatelessWidget {
  const _FulfillmentOptionTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Opacity(
      opacity: isDisabled && !isSelected ? 0.7 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(Spacing.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.08)
                  : colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(Spacing.md),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : colors.outline.withValues(alpha: 0.2),
                width: isSelected ? 1.8 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary
                            : colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Spacing.sm),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: isSelected
                            ? colors.onPrimary
                            : colors.primary,
                      ),
                    ),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
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
                const SizedBox(height: Spacing.sm),
                Text(
                  label,
                  style: getBoldStyle(
                    fontSize: FontSize.size13,
                    fontFamily: FontConstant.cairo,
                    color: isSelected ? colors.primary : colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontSize: FontSize.size11,
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
