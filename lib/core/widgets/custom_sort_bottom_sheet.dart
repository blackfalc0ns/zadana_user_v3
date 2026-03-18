import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_sort_option_item.dart';

class CustomSortBottomSheet extends StatefulWidget {
  const CustomSortBottomSheet({
    super.key,
    this.selectedSortOption,
    required this.sortOptions,
    this.title = 'ترتيب حسب',
    this.cancelLabel = 'إلغاء',
    this.applyLabel = 'تطبيق',
  });

  final String? selectedSortOption;
  final List<Map<String, dynamic>> sortOptions; // تغيير النوع
  final String title;
  final String cancelLabel;
  final String applyLabel;

  @override
  State<CustomSortBottomSheet> createState() => _CustomSortBottomSheetState();
}

class _CustomSortBottomSheetState extends State<CustomSortBottomSheet> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedSortOption;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: color.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    widget.cancelLabel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(widget.title, style: AppTextStyles.h3),
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedOption),
                  child: Text(
                    widget.applyLabel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: color.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
              itemCount: widget.sortOptions.length,
              itemBuilder: (context, index) {
                final option = widget.sortOptions[index];
                final isSelected = selectedOption == option['value'];

                return CustomSortOptionItem(
                  title: option['title'] ?? '',
                  subtitle: option['subtitle'],
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedOption = option['value'];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}