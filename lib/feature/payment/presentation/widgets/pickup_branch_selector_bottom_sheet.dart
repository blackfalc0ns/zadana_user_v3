import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/pickup_branch_option_entity.dart';

class PickupBranchSelectorBottomSheet extends StatelessWidget {
  const PickupBranchSelectorBottomSheet({
    super.key,
    required this.branches,
    required this.selectedBranchId,
    required this.isLoading,
    required this.failure,
  });

  final List<PickupBranchOptionEntity> branches;
  final String? selectedBranchId;
  final bool isLoading;
  final Failure? failure;

  static Future<String?> show(
    BuildContext context, {
    required List<PickupBranchOptionEntity> branches,
    required String? selectedBranchId,
    required bool isLoading,
    required Failure? failure,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => PickupBranchSelectorBottomSheet(
        branches: branches,
        selectedBranchId: selectedBranchId,
        isLoading: isLoading,
        failure: failure,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eligibleBranches = branches
        .where((branch) => branch.canFulfillCart)
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.pickup_branch_selector_title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.pickup_branch_selector_hint,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (failure != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  failure!.errorMessage,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              )
            else if (branches.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l10n.pickup_branch_selector_empty),
              )
            else if (eligibleBranches.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l10n.pickup_branch_selector_cart_unavailable),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: branches.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    return _PickupBranchOptionCard(
                      branch: branch,
                      isSelected: branch.id == selectedBranchId,
                      onSelected: () => Navigator.of(context).pop(branch.id),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PickupBranchOptionCard extends StatelessWidget {
  const _PickupBranchOptionCard({
    required this.branch,
    required this.isSelected,
    required this.onSelected,
  });

  final PickupBranchOptionEntity branch;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isEnabled = branch.canFulfillCart;
    final availabilityColor = isEnabled ? colors.primary : colors.error;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onSelected : null,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: 0.07)
                : isEnabled
                ? colors.surface
                : colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: isSelected ? 2 : 1,
              color: isSelected ? colors.primary : colors.outlineVariant,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: availabilityColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  color: availabilityColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            branch.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isEnabled
                                      ? colors.onSurface
                                      : colors.onSurfaceVariant,
                                ),
                          ),
                        ),
                        if (branch.isPrimary) ...[
                          const SizedBox(width: Spacing.xs),
                          _StatusBadge(
                            label: l10n.pickup_branch_primary,
                            color: colors.secondary,
                          ),
                        ],
                      ],
                    ),
                    if (branch.displayAddress.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _BranchDetail(
                        icon: Icons.location_on_outlined,
                        value: branch.displayAddress,
                      ),
                    ],
                    if ((branch.hoursToday ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 5),
                      _BranchDetail(
                        icon: Icons.schedule_outlined,
                        value: branch.hoursToday!,
                        valueDirection: TextDirection.ltr,
                      ),
                    ],
                    const SizedBox(height: 10),
                    _StatusBadge(
                      label: isEnabled
                          ? l10n.pickup_branch_cart_available
                          : l10n.pickup_branch_cart_unavailable(
                              branch.missingItemsCount,
                            ),
                      color: availabilityColor,
                      icon: isEnabled
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? colors.primary : colors.outline,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchDetail extends StatelessWidget {
  const _BranchDetail({
    required this.icon,
    required this.value,
    this.valueDirection,
  });

  final IconData icon;
  final String value;
  final TextDirection? valueDirection;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colors.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textDirection: valueDirection,
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
