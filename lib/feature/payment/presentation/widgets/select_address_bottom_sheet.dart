import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class SelectAddressBottomSheet extends StatelessWidget {
  const SelectAddressBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SelectAddressBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    // TODO: Replace with actual saved addresses from your state management
    final savedAddresses = [
      {'name': l10n.nav_home, 'address': l10n.location, 'isSelected': true},
      {'name': 'العمل', 'address': 'شارع الملك فهد، الرياض', 'isSelected': false},
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.cardRadius + 8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Spacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
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
                    size: 20,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Text(
                  l10n.addresses,
                  style: getBoldStyle(
                    fontSize: FontSize.size16,
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),

          // Addresses list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Spacing.lg),
              itemCount: savedAddresses.length,
              separatorBuilder: (context, index) => const SizedBox(height: Spacing.sm),
              itemBuilder: (context, index) {
                final address = savedAddresses[index];
                final isSelected = address['isSelected'] as bool;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Spacing.md),
                    onTap: () {
                      // TODO: Update selected address in your state management
                      Navigator.pop(context, address);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withValues(alpha: 0.08)
                            : colors.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(Spacing.md),
                        border: Border.all(
                          color: isSelected
                              ? colors.primary.withValues(alpha: 0.3)
                              : colors.outlineVariant.withValues(alpha: 0.3),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(Spacing.sm),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary.withValues(alpha: 0.15)
                                  : colors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(Spacing.sm),
                            ),
                            child: Icon(
                              isSelected ? Icons.location_on : Icons.location_on_outlined,
                              color: isSelected ? colors.primary : colors.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      address['name'] as String,
                                      style: getBoldStyle(
                                        fontSize: FontSize.size14,
                                        fontFamily: FontConstant.cairo,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: Spacing.xs),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Spacing.sm,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.primary,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          l10n.currently_selected,
                                          style: getMediumStyle(
                                            fontSize: FontSize.size9,
                                            fontFamily: FontConstant.cairo,
                                            color: colors.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  address['address'] as String,
                                  style: getRegularStyle(
                                    fontSize: FontSize.size12,
                                    fontFamily: FontConstant.cairo,
                                    color: colors.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Add new address button
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(
                  Icons.add_location_outlined,
                  color: colors.primary,
                ),
                label: Text(
                  l10n.add_address,
                  style: getBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: colors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  side: BorderSide(color: colors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.md),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  // Navigate to add address flow
                  await Navigator.pushNamed(
                    context,
                    AppRoutes.startSelectLocationPage,
                  );
                },
              ),
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

