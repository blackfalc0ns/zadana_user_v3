import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    this.controller,
    this.onFilterTap,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.padding = const EdgeInsets.symmetric(horizontal: Spacing.screenH),
    this.backgroundColor,
  });

  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: padding,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                onChanged: onChanged,
                onTap: onTap,
                readOnly: readOnly,
                autofocus: autofocus,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: l10n.search_hint,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textHint,
                  ),
                  isDense: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: SvgPicture.asset(
                      'assets/images/search-normal.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textHint,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (onFilterTap != null) ...[
              const SizedBox(width: 10),
              InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(14),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
