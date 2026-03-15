import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/constants/styles_manger.dart';

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
  final String? selectedVendorId; // تغيير إلى nullable
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: selectedVendorId == null
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
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
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: vendors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) => _VendorChip(
                vendor: vendors[i],
                isSelected: vendors[i].id == selectedVendorId,
                hasSelection: selectedVendorId != null,
                onTap: () => onVendorSelected(vendors[i].id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorChip extends StatelessWidget {
  final VendorModel vendor;
  final bool isSelected;
  final bool hasSelection;
  final VoidCallback onTap;

  const _VendorChip({
    required this.vendor,
    required this.isSelected,
    required this.hasSelection,
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
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : !hasSelection
              ? null
              : null,
          color: !isSelected && hasSelection
              ? AppColors.background
              : !hasSelection
              ? AppColors.surface
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : !hasSelection
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: !hasSelection
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vendor.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              vendor.name,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                color: isSelected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
