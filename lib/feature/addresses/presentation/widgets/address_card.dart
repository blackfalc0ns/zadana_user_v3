import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.item,
    required this.isSelectedDefault,
    required this.isDeleting,
    required this.canDelete,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  final CustomerAddressEntity item;
  final bool isSelectedDefault;
  final bool isDeleting;
  final bool canDelete;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelectedDefault ? AppColors.primary : AppColors.border,
          width: isSelectedDefault ? 1.2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AddressCardHeader(
            item: item,
            isSelectedDefault: isSelectedDefault,
            isDeleting: isDeleting,
            canDelete: canDelete,
            l10n: l10n,
            onDelete: onDelete,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            item.addressLine,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: AppColors.textSecondary,
            ).copyWith(height: 1.4),
          ),
          const SizedBox(height: Spacing.md),
          _AddressCardActions(
            isDeleting: isDeleting,
            isSelectedDefault: isSelectedDefault,
            l10n: l10n,
            onEdit: onEdit,
            onSetDefault: onSetDefault,
          ),
        ],
      ),
    );
  }
}

class _AddressCardHeader extends StatelessWidget {
  const _AddressCardHeader({
    required this.item,
    required this.isSelectedDefault,
    required this.isDeleting,
    required this.canDelete,
    required this.l10n,
    required this.onDelete,
  });

  final CustomerAddressEntity item;
  final bool isSelectedDefault;
  final bool isDeleting;
  final bool canDelete;
  final AppLocalizations l10n;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: (isSelectedDefault
                    ? AppColors.primary
                    : AppColors.primaryLight)
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.location_on_outlined,
            color: isSelectedDefault
                ? AppColors.primary
                : AppColors.primaryLight,
            size: 20,
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: Spacing.xs,
                runSpacing: Spacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _localizedLabel(l10n, item.label),
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (isSelectedDefault)
                    _DefaultBadge(label: l10n.addresses_default),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _compactLocation(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (canDelete)
          IconButton(
            onPressed: isDeleting ? null : onDelete,
            tooltip: l10n.addresses_delete,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.08),
              minimumSize: const Size(38, 38),
              padding: EdgeInsets.zero,
            ),
            icon: isDeleting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
          ),
      ],
    );
  }

  String _localizedLabel(AppLocalizations l10n, String value) {
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

  String _compactLocation(CustomerAddressEntity item) {
    final parts = <String>[
      if (item.city.trim().isNotEmpty) item.city,
      if (item.area.trim().isNotEmpty && item.area != item.city) item.area,
    ];
    return parts.join(' - ');
  }
}

class _AddressCardActions extends StatelessWidget {
  const _AddressCardActions({
    required this.isDeleting,
    required this.isSelectedDefault,
    required this.l10n,
    required this.onEdit,
    required this.onSetDefault,
  });

  final bool isDeleting;
  final bool isSelectedDefault;
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isDeleting ? null : onEdit,
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              minimumSize: const Size.fromHeight(42),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(l10n.addresses_edit),
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        if (isSelectedDefault)
          Expanded(
            child: Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.addresses_current,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isDeleting ? null : onSetDefault,
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                minimumSize: const Size.fromHeight(42),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 16),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(l10n.addresses_set_default),
              ),
            ),
          ),
      ],
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  const _DefaultBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size11,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
