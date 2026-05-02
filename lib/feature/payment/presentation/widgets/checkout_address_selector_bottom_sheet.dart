import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/addresses/domain/entities/customer_address_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';

class CheckoutAddressSelectorBottomSheet extends StatelessWidget {
  const CheckoutAddressSelectorBottomSheet({
    super.key,
    required this.addresses,
    required this.selectedAddressId,
    required this.isLoading,
    this.failure,
  });

  static const String addNewAddressResult = 'add_new_address';

  final List<CustomerAddressEntity> addresses;
  final String? selectedAddressId;
  final bool isLoading;
  final Failure? failure;

  static Future<String?> show(
    BuildContext context, {
    required List<CustomerAddressEntity> addresses,
    required String? selectedAddressId,
    required bool isLoading,
    Failure? failure,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckoutAddressSelectorBottomSheet(
        addresses: addresses,
        selectedAddressId: selectedAddressId,
        isLoading: isLoading,
        failure: failure,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: Spacing.md),
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: colors.outlineVariant,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
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
                    Icons.location_on_outlined,
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
          Divider(height: 1, color: colors.outlineVariant.withValues(alpha: 0.5)),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: _buildContent(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              0,
              Spacing.lg,
              Spacing.lg,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context, addNewAddressResult),
                icon: Icon(Icons.add_location_alt_outlined, color: colors.primary),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Spacing.md),
                  ),
                  side: BorderSide(color: colors.primary),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (failure != null && addresses.isEmpty) {
      return Center(child: InlineApiErrorWidget(failure: failure!));
    }

    if (addresses.isEmpty) {
      return Center(
        child: Text(
          l10n.add_address,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            color: colors.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: addresses.length,
      separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
      itemBuilder: (context, index) {
        final address = addresses[index];
        final isSelected = address.id == selectedAddressId;

        return InkWell(
          onTap: () => Navigator.pop(context, address.id),
          borderRadius: BorderRadius.circular(Spacing.md),
          child: Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.08)
                  : colors.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(Spacing.md),
              border: Border.all(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.28)
                    : colors.outlineVariant.withValues(alpha: 0.35),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSelected ? Icons.location_on : Icons.location_on_outlined,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizeAddressLabel(l10n, address.label),
                        style: getBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.addressLine,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: colors.primary, size: 22),
              ],
            ),
          ),
        );
      },
    );
  }
}
