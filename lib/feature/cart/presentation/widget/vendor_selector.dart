import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_vendor_entity.dart';

class VendorSelector extends StatelessWidget {
  const VendorSelector({
    super.key,
    required this.vendors,
    required this.selectedVendorId,
    required this.onVendorSelected,
  });

  final List<CartVendorEntity> vendors;
  final String? selectedVendorId;
  final void Function(String) onVendorSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: color.surface,
        boxShadow: selectedVendorId == null
            ? [
                BoxShadow(
                  color: color.primary.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          if (selectedVendorId == null)
            Container(
              width: double.infinity,
              height: 2,
              color: color.primary.withValues(alpha: 0.2),
            ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: vendors.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, index) => _VendorChip(
                vendor: vendors[index],
                isSelected: vendors[index].id == selectedVendorId,
                hasSelection: selectedVendorId != null,
                onTap: () => onVendorSelected(vendors[index].id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorChip extends StatelessWidget {
  const _VendorChip({
    required this.vendor,
    required this.isSelected,
    required this.hasSelection,
    required this.onTap,
  });

  final CartVendorEntity vendor;
  final bool isSelected;
  final bool hasSelection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary
              : !hasSelection
              ? color.surface
              : color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: !hasSelection
              ? [
                  BoxShadow(
                    color: color.primary.withValues(alpha: 0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 36,
                height: 36,
                child: CachedNetworkImage(
                  imageUrl: vendor.logoUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      ColoredBox(color: color.surfaceContainerHighest),
                  errorWidget: (_, _, _) => Image.asset(
                    'assets/images/image_not_found.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              vendor.name,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                color: isSelected ? color.onPrimary : color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
