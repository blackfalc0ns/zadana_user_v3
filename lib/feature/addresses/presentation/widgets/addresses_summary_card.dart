import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class AddressesSummaryCard extends StatelessWidget {
  const AddressesSummaryCard({
    super.key,
    required this.count,
    required this.defaultLabel,
  });

  final int count;
  final String defaultLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final colors = Theme.of(context).colorScheme;
    final localizedDefaultLabel = _localizedLabel(l10n, defaultLabel);

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primary.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.addresses,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.addresses_summary_default(localizedDefaultLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$count',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size18,
                    color: colors.primary,
                  ),
                ),
                Text(
                  l10n.addresses,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size8,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _localizedLabel(dynamic l10n, String value) {
    switch (value.trim()) {
      case 'Home':
        return l10n.location_address_label_home;
      case 'Work':
        return l10n.location_address_label_work;
      case 'Other':
        return l10n.location_address_label_other;
      default:
        return value;
    }
  }
}
