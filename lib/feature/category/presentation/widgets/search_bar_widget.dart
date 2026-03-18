import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    this.onFilterApplied,
    required this.locale,
  });

  final Function(Map<String, dynamic>)? onFilterApplied;
  final AppLocalizations locale;

  void _showFilterBottomSheet(BuildContext context) {
    // TODO: Implement filter functionality or remove if not needed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              style: getRegularStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
                color: color.onSurface,
              ),
              decoration: InputDecoration(
                hintText: locale.search_hint,
                hintStyle: getRegularStyle(
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface.withValues(alpha: 0.5),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      Assets.searchNormal,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            width: 42,
            height: 48,
            decoration: BoxDecoration(
              color: color.primary,
              border: Border.all(color: color.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () => _showFilterBottomSheet(context),
              icon: Icon(Icons.tune, color: color.onPrimary, size: 24),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
