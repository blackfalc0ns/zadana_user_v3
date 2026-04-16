import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
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
    required this.selectedAddress,
    required this.selectedSlot,
    required this.onChangeAddress,
    this.isRefreshing = false,
  });

  final CheckoutAddressEntity? selectedAddress;
  final CheckoutDeliverySlotEntity? selectedSlot;
  final VoidCallback onChangeAddress;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.local_shipping_outlined,
            title: l10n.shipping,
            trailing: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: isRefreshing ? null : onChangeAddress,
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
                          l10n.change_address,
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
          if (selectedAddress != null)
            _SelectedAddressTile(address: selectedAddress!)
          else
            _MissingAddressTile(onChangeAddress: onChangeAddress),
          const SizedBox(height: Spacing.sm),
          _SelectedSlotTile(slot: selectedSlot),
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
  const _MissingAddressTile({required this.onChangeAddress});

  final VoidCallback onChangeAddress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onChangeAddress,
      borderRadius: BorderRadius.circular(Spacing.sm + 2),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: colors.error.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(Spacing.sm + 2),
          border: Border.all(color: colors.error.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Icon(Icons.add_location_alt_outlined, color: colors.error),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                l10n.add_address,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: colors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedSlotTile extends StatelessWidget {
  const _SelectedSlotTile({required this.slot});

  final CheckoutDeliverySlotEntity? slot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Spacing.sm + 2),
        border: Border.all(color: colors.secondary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
            child: Icon(Icons.schedule, color: colors.secondary, size: 18),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.estimated_delivery,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  slot?.label ?? l10n.not_available,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: colors.secondary,
                  ),
                ),
              ],
            ),
          ),
          InfoBadge(
            text: slot?.isAvailable == true ? l10n.available : l10n.not_available,
            backgroundColor: slot?.isAvailable == true
                ? colors.secondary
                : AppColors.error,
            textColor: AppColors.white,
            fontSize: FontSize.size10,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.xs,
            ),
          ),
        ],
      ),
    );
  }
}
