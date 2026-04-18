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
  });

  final AppLocalizations locale;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClose;
  final VoidCallback? onFilterTap;

  bool get _isInteractiveSearch =>
      controller != null && focusNode != null && onChanged != null;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

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
                          suffixIcon: (value.text.isEmpty && onClose == null)
                              ? null
                              : SizedBox(
                                  width: onClose == null ? 48 : 88,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (value.text.isNotEmpty)
                                        IconButton(
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
                                      if (onClose != null)
                                        IconButton(
                                          onPressed: onClose,
                                          icon: Icon(
                                            Icons.arrow_forward_rounded,
                                            color: color.onSurfaceVariant,
                                            size: 22,
                                          ),
                                        ),
                                    ],
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              width: 42,
              height: 48,
              decoration: BoxDecoration(
                //  color: color.primary,
                border: Border.all(color: color.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: onFilterTap,
                icon: Icon(Icons.tune, color: color.onPrimary, size: 24),
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
    );
  }
}
