import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
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
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
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
                            padding: const EdgeInsets.all(12.0),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: color.surfaceContainerLowest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
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
                        padding: const EdgeInsets.all(12.0),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: color.surfaceContainerLowest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
          ),
          if (onFilterTap != null)
            Container(
              constraints: BoxConstraints(
                minWidth: isFilterDestructive ? 88 : 48,
                minHeight: 48,
              ),
              margin: const EdgeInsetsDirectional.only(start: 8),
              decoration: BoxDecoration(
                color: actionColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    focusNode?.unfocus();
                    onClose?.call();
                    onFilterTap!();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isFilterDestructive ? 14 : 12,
                      vertical: 12,
                    ),
                    child: isFilterDestructive
                        ? Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                filterTooltip ?? locale.delete_category_tooltip,
                                style: getRegularStyle(
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                  color: color.onPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        : Icon(filterIcon, color: color.onPrimary, size: 20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
