import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_badge.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class CheckoutDeliveryInfoCard extends StatelessWidget {
  const CheckoutDeliveryInfoCard({
    super.key,
    required this.fulfillmentType,
    required this.selectedAddress,
    required this.pickupBranch,
    required this.onChangeAddress,
    required this.onChangePickupBranch,
    this.isRefreshing = false,
  });

  final String fulfillmentType;
  final CheckoutAddressEntity? selectedAddress;
  final CheckoutBranchEntity? pickupBranch;
  final VoidCallback onChangeAddress;
  final VoidCallback onChangePickupBranch;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isPickup = isPickupFulfillmentType(fulfillmentType);

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: isPickup
                ? Icons.storefront_outlined
                : Icons.local_shipping_outlined,
            title: resolveFulfillmentTitle(context, l10n, fulfillmentType),
            trailing: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: isRefreshing
                    ? null
                    : (isPickup ? onChangePickupBranch : onChangeAddress),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: isRefreshing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primary,
                          ),
                        )
                      : Text(
                          isPickup
                              ? (isArabicPaymentLocale(context)
                                    ? 'اختيار الفرع'
                                    : 'Select branch')
                              : resolveFulfillmentActionLabel(
                                  context,
                                  fulfillmentType,
                                ),
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            color: colors.primary,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          if (isPickup && pickupBranch != null)
            _SelectedBranchTile(branch: pickupBranch!)
          else if (!isPickup && selectedAddress != null)
            _SelectedAddressTile(address: selectedAddress!)
          else
            _MissingAddressTile(fulfillmentType: fulfillmentType),
        ],
      ),
    );
  }
}

class _SelectedBranchTile extends StatelessWidget {
  const _SelectedBranchTile({required this.branch});

  final CheckoutBranchEntity branch;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasAddress = branch.displayAddress.isNotEmpty;
    final hasHours = (branch.hoursToday ?? '').trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(Spacing.sm + 2),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Icon(Icons.storefront, color: colors.primary, size: 18),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  style: getBoldStyle(
                    fontSize: FontSize.size13,
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurface,
                  ),
                ),
                if (hasAddress) ...[
                  const SizedBox(height: 4),
                  Text(
                    isArabicPaymentLocale(context)
                        ? 'عنوان الفرع'
                        : 'Branch address',
                    style: getMediumStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    branch.displayAddress,
                    style: getRegularStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
                if (hasHours) ...[
                  const SizedBox(height: 4),
                  Text(
                    isArabicPaymentLocale(context)
                        ? 'مواعيد اليوم'
                        : 'Today hours',
                    style: getMediumStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    branch.hoursToday!,
                    style: getRegularStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedAddressTile extends StatelessWidget {
  const _SelectedAddressTile({required this.address});

  final CheckoutAddressEntity address;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(Spacing.sm + 2),
        border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Icon(Icons.location_on, color: colors.primary, size: 18),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        localizeAddressLabel(l10n, address.label),
                        style: getBoldStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    if (address.isDefault)
                      InfoBadge(
                        text: l10n.currently_selected,
                        backgroundColor: colors.secondary.withValues(alpha: 0.1),
                        textColor: colors.secondary,
                        fontSize: FontSize.size9,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: 2,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address.addressLine,
                  style: getRegularStyle(
                    fontSize: FontSize.size11,
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingAddressTile extends StatelessWidget {
  const _MissingAddressTile({required this.fulfillmentType});

  final String fulfillmentType;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isPickup = isPickupFulfillmentType(fulfillmentType);

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: (isPickup ? colors.primary : colors.error).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(Spacing.sm + 2),
        border: Border.all(
          color: (isPickup ? colors.primary : colors.error).withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPickup ? Icons.storefront_outlined : Icons.add_location_alt_outlined,
            color: isPickup ? colors.primary : colors.error,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resolveMissingFulfillmentLabel(context, fulfillmentType),
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: isPickup ? colors.primary : colors.error,
                  ),
                ),
                if (isPickup) ...[
                  const SizedBox(height: 6),
                  Text(
                    isArabicPaymentLocale(context)
                        ? 'لا يمكن إكمال الطلب حتى يتم اختيار فرع استلام متاح لكل منتجات السلة.'
                        : 'Checkout stays disabled until an available pickup branch is selected.',
                    style: getRegularStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
