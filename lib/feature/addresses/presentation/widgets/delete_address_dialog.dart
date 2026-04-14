import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';

class DeleteAddressDialog extends StatelessWidget {
  const DeleteAddressDialog({super.key, required this.item});

  final CustomerAddressEntity item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 28,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              l10n.addresses_delete_title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size20,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              l10n.addresses_delete_confirm(_localizedLabel(l10n, item.label)),
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: AppColors.textSecondary,
              ).copyWith(height: 1.5),
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(l10n.addresses_delete),
                  ),
                ),
              ],
            ),
          ],
        ),
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
