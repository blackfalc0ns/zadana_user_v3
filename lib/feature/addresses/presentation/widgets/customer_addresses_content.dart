import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/empty_state_widget.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/widgets/address_card.dart';
import 'package:zadana_user_v3/feature/addresses/presentation/widgets/addresses_summary_card.dart';

class CustomerAddressesContent extends StatelessWidget {
  const CustomerAddressesContent({
    super.key,
    required this.items,
    required this.selectedDefaultId,
    required this.deletingAddressId,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CustomerAddressEntity> items;
  final String? selectedDefaultId;
  final String? deletingAddressId;
  final ValueChanged<CustomerAddressEntity> onSetDefault;
  final ValueChanged<CustomerAddressEntity> onEdit;
  final ValueChanged<CustomerAddressEntity> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    if (items.isEmpty) {
      return EmptyStateWidget(
        title: l10n.addresses,
        description: l10n.profile_addresses_subtitle,
        icon: Icons.location_on_outlined,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.base,
        Spacing.base,
        Spacing.xl,
      ),
      children: [
        AddressesSummaryCard(
          count: items.length,
          defaultLabel: _resolveDefaultLabel(l10n),
        ),
        const SizedBox(height: Spacing.base),
        for (final item in items) ...[
          AddressCard(
            item: item,
            isSelectedDefault: item.id == selectedDefaultId,
            isDeleting: deletingAddressId == item.id,
            canDelete: items.length > 1,
            onSetDefault: () => onSetDefault(item),
            onEdit: () => onEdit(item),
            onDelete: () => onDelete(item),
          ),
          const SizedBox(height: Spacing.md),
        ],
      ],
    );
  }

  String _resolveDefaultLabel(AppLocalizations l10n) {
    final selected = items
        .where((item) => item.id == selectedDefaultId)
        .firstOrNull;
    return selected?.label ?? l10n.addresses_primary_label;
  }
}
