import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'animated_search_hint.dart';

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
    return Padding(
      padding: padding,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white.withAlpha(50)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _EmptyStateHint(controller: controller),
                  TextFormField(
                    controller: controller,
                    onChanged: onChanged,
                    onTap: onTap,
                    readOnly: readOnly,
                    autofocus: autofocus,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      prefixIcon: _SearchPrefixIcon(),
                    ),
                  ),
                ],
              ),
            ),
            if (onFilterTap != null) _FilterAction(onTap: onFilterTap!),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateHint extends StatelessWidget {
  const _EmptyStateHint({required this.controller});
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    if (controller == null) return const AnimatedSearchHint();

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller!,
      builder: (context, value, _) {
        return value.text.isEmpty ? const AnimatedSearchHint() : const SizedBox.shrink();
      },
    );
  }
}

class _SearchPrefixIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: SvgPicture.asset(
        'assets/images/search-normal.svg',
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
      ),
    );
  }
}

class _FilterAction extends StatelessWidget {
  const _FilterAction({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: const Icon(Icons.tune_rounded, size: 20, color: AppColors.white),
      ),
    );
  }
}
