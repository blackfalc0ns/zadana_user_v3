import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/location/domain/entities/location_search_entity.dart';

class LocationSearchResultsList extends StatelessWidget {
  const LocationSearchResultsList({
    super.key,
    required this.results,
    required this.onSelect,
  });
  final List<LocationSearchResultEntity> results;
  final ValueChanged<LocationSearchResultEntity> onSelect;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return const SizedBox.shrink();
    final color = context.colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: Spacing.sm, left: 52),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        itemCount: results.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: Spacing.base,
          endIndent: Spacing.base,
          color: color.outlineVariant.withValues(alpha: 0.5),
        ),
        itemBuilder: (context, index) {
          final result = results[index];

          return ListTile(
            dense: true,
            leading: Icon(
              Icons.location_on,
              color: color.primary,
              size: Spacing.iconMd,
            ),
            title: Text(
              result.addressLine,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall.copyWith(color: color.onSurface),
            ),
            onTap: () => onSelect(result),
          );
        },
      ),
    );
  }
}
