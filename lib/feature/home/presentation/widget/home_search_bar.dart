// import 'package:flutter/material.dart';
// import 'package:zadana_user_v3/config/theme/colors.dart';
// import 'package:zadana_user_v3/config/theme/spacing.dart';
// import 'package:zadana_user_v3/config/theme/text_styles.dart';

// class HomeSearchBar extends StatelessWidget {
//   const HomeSearchBar({
//     super.key,
//     required this.hint,
//     this.onTap,
// });

//   final String hint;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
//         height: 46,
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           borderRadius: BorderRadius.circular(Spacing.inputRadius),
//           border: Border.all(color: AppColors.border),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
//         child: Row(
//           children: [
//             const Icon(
//               Icons.search_rounded,
//               color: AppColors.textHint,
//               size: 20,
//             ),
//             const SizedBox(width: Spacing.sm),
//             Text(
//               hint,
//               style: AppTextStyles.inputHint,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onFilterTap,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Filter icon — على اليمين في RTL ─────────────
            GestureDetector(
              onTap: onFilterTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(
                  Icons.tune_rounded,
                  color: onFilterTap != null
                      ? AppColors.primary
                      : AppColors.textHint,
                  size: 20,
                ),
              ),
            ),
      
            // ── Divider ──────────────────────────────────────
            Container(
              width: 1,
              height: 24,
              color: AppColors.border,
            ),
      
            // ── Search icon + field ──────────────────────────
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
                  suffixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
