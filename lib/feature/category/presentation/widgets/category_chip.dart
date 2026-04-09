import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_filter_chip.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return CustomFilterChip(
      label: label,
      icon: emoji.isEmpty ? null : emoji,
      isSelected: isSelected,
      onTap: onTap ?? () {},
      backgroundColor: color.surface,
      selectedColor: color.primary,
      borderColor: color.onSurface,
      textStyle: getMediumStyle(
        fontSize: FontSize.size14,
        fontFamily: FontConstant.cairo,
        color: isSelected ? color.onPrimary : color.onSurface,
      ),
    );
  }
}
