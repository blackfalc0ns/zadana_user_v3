import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class BrandSearchBarDelegate extends SliverPersistentHeaderDelegate {
  BrandSearchBarDelegate({
    required this.brandName,
    required this.onActionPressed,
    this.onSearchTap,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onClose,
    this.actionIcon = Icons.tune_rounded,
    this.actionTooltip,
    this.isActionDestructive = false,
  });

  final String brandName;
  final VoidCallback onActionPressed;
  final VoidCallback? onSearchTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClose;
  final IconData actionIcon;
  final String? actionTooltip;
  final bool isActionDestructive;

  bool get _isInteractiveSearch =>
      controller != null && focusNode != null && onChanged != null;

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final color = context.colorScheme;
    final actionColor = isActionDestructive ? color.error : color.primary;

    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              onTap: onSearchTap,
                              onChanged: onChanged,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: context.localization
                                    .search_in_brand_products(brandName),
                                hintStyle: getRegularStyle(
                                  fontFamily: FontConstant.cairo,
                                  color: color.onSurfaceVariant,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/images/search-normal.svg',
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
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: color.onSurface,
                              ),
                            );
                          },
                        )
                      : TextField(
                          readOnly: true,
                          onTap: onSearchTap,
                          decoration: InputDecoration(
                            hintText: context.localization
                                .search_in_brand_products(brandName),
                            hintStyle: getRegularStyle(
                              fontFamily: FontConstant.cairo,
                              color: color.onSurfaceVariant,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset(
                                'assets/images/search-normal.svg',
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
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: color.onSurface,
                          ),
                        ),
                ),
                Container(
                  constraints: BoxConstraints(
                    minWidth: isActionDestructive ? 88 : 44,
                    minHeight: 44,
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
                        onActionPressed();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isActionDestructive ? 14 : 12,
                          vertical: 12,
                        ),
                        child: isActionDestructive
                            ? Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    actionTooltip ??
                                        context
                                            .localization
                                            .delete_category_tooltip,
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
                            : Icon(
                                actionIcon,
                                color: color.onPrimary,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
