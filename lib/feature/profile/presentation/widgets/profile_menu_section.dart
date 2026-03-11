import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_menu_item.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/profile_menu_item_data.dart';

class ProfileMenuSection extends StatelessWidget {
  final List<ProfileMenuItemData> items;

  const ProfileMenuSection({
    super.key,
   
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(Spacing.base),
          // //   child: Text(
          // //  //   title,
          // //     style: textTheme.titleMedium?.copyWith(
          // //       fontWeight: FontWeight.bold,
          // //     ),
          //   ),
        //  ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ProfileMenuItem(
                  icon: item.icon,
                  title: item.title,
                  onTap: item.onTap,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
