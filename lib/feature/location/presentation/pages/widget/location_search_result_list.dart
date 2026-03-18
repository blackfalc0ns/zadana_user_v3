import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';

class LocationSearchResultsList extends StatelessWidget {
  final List<LocationSearchResultEntity> results;
  final ValueChanged<LocationSearchResultEntity> onSelect;

  const LocationSearchResultsList({
    super.key,
    required this.results,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(
        top: Spacing.sm,
        right: 55
      ),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        itemCount: results.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          indent: Spacing.base,
          endIndent: Spacing.base,
        ),
        itemBuilder: (context, index) {
          final result = results[index];

          return ListTile(
            dense: true,
            leading: const Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: Spacing.iconMd,
            ),
            title: Text(
              result.addressLine,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall,
            ),
            onTap: () => onSelect(result),
          );
        },
      ),
    );
  }
}