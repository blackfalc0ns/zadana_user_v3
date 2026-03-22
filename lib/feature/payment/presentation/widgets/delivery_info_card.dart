import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_badge.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/select_address_bottom_sheet.dart';

class DeliveryInfoCard extends StatelessWidget {
  const DeliveryInfoCard({super.key});

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
                onTap: () {
                  SelectAddressBottomSheet.show(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    l10n.change_address,
                    style: getBoldStyle(
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          
          // Address
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(Spacing.sm + 2),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.12),
                width: 1,
              ),
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
                  child: Icon(
                    Icons.location_on,
                    color: colors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.nav_home,
                            style: getBoldStyle(
                              fontSize: FontSize.size13,
                              fontFamily: FontConstant.cairo,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
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
                        l10n.location,
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
          ),
          
          const SizedBox(height: Spacing.sm),
          
          // Delivery Time
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(Spacing.sm + 2),
              border: Border.all(
                color: colors.secondary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: colors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Spacing.sm),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: colors.secondary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.estimated_delivery,
                        style: getMediumStyle(
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            '30-45 ${l10n.minutes}',
                            style: getBoldStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                              color: colors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InfoBadge(
                  text: l10n.available,
                  backgroundColor: colors.secondary,
                  textColor: colors.onSecondary,
                  fontSize: FontSize.size10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.xs,
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