import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';

class VendorModel {
  final String id;
  final String name;
  final String emoji;

  const VendorModel({
    required this.id,
    required this.name,
    required this.emoji,
  });
}

final List<VendorModel> dummyVendors = [
  const VendorModel(id: 'v1', name: 'كارفور', emoji: '🛒'),
  const VendorModel(id: 'v2', name: 'سبينس', emoji: '🏪'),
  const VendorModel(id: 'v3', name: 'هايبر وان', emoji: '🏬'),
  const VendorModel(id: 'v4', name: 'بشاير', emoji: '🛍️'),
  const VendorModel(id: 'v5', name: 'أونستوب', emoji: '🏪'),
  const VendorModel(id: 'v6', name: 'فاتورة', emoji: '📦'),
  const VendorModel(id: 'v7', name: 'جملة', emoji: '🏭'),
];

class VendorSelector extends StatelessWidget {
  final List<VendorModel> vendors;
  final String selectedVendorId;
  final void Function(String) onVendorSelected;

  const VendorSelector({
    super.key,
    required this.vendors,
    required this.selectedVendorId,
    required this.onVendorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: AppColors.surface,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: vendors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _VendorChip(
          vendor: vendors[i],
          isSelected: vendors[i].id == selectedVendorId,
          onTap: () => onVendorSelected(vendors[i].id),
        ),
      ),
    );
  }
}

class _VendorChip extends StatelessWidget {
  final VendorModel vendor;
  final bool isSelected;
  final VoidCallback onTap;

  const _VendorChip({
    required this.vendor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vendor.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              vendor.name,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
