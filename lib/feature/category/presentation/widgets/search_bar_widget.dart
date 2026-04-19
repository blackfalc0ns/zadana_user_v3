import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/constants/assets.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.locale,
    this.onTap,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onClose,
    this.onFilterTap,
    this.filterIcon = Icons.tune_rounded,
    this.filterTooltip,
    this.isFilterDestructive = false,
  });

  final AppLocalizations locale;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClose;
  final VoidCallback? onFilterTap;
  final IconData filterIcon;
  final String? filterTooltip;
  final bool isFilterDestructive;

  bool get _isInteractiveSearch =>
      controller != null && focusNode != null && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final actionColor = isFilterDestructive ? color.error : color.primary;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        border: Border.all(color: AppColors.border, width: .1),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _isInteractiveSearch
                ? ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller!,
                    builder: (context, value, _) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onTap: onTap,
                        onChanged: onChanged,
                        textAlign: TextAlign.right,
                        textInputAction: TextInputAction.search,
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
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(
                                Assets.searchNormal,
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                  color.onSurfaceVariant,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: value.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    controller!.clear();
                                    onChanged!('');
                                  },
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: color.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.sm,
                          ),
                        ),
                      );
                    },
                  )
                : TextField(
                    readOnly: true,
                    onTap: onTap,
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
                          padding: const EdgeInsets.all(2.0),
                          child: SvgPicture.asset(
                            Assets.searchNormal,
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              color.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
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
          if (onFilterTap != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 6, start: 2),
              child: Material(
                color: actionColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onFilterTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: actionColor.withValues(alpha: 0.22),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          actionColor.withValues(alpha: 0.14),
                          actionColor.withValues(alpha: 0.06),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: actionColor.withValues(alpha: 0.10),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Tooltip(
                      message: filterTooltip ?? '',
                      child: Icon(filterIcon, color: actionColor, size: 21),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
