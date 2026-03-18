import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/profile/presentation/widgets/language_option_widget.dart';

class LanguageBottomSheetWidget extends StatelessWidget {
  const LanguageBottomSheetWidget({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const LanguageBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Spacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: color.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: Spacing.base),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
            child: Text(
              'اختر اللغة',
              style: getBoldStyle(
                fontSize: FontSize.size18,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
          const SizedBox(height: Spacing.base),
          LanguageOptionWidget(
            title: 'العربية',
            subtitle: 'Arabic',
            isSelected: true,
            onTap: () {
              Navigator.pop(context);
              // TODO: Change language to Arabic
            },
          ),
          const Divider(height: 1),
          LanguageOptionWidget(
            title: 'English',
            subtitle: 'الإنجليزية',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              // TODO: Change language to English
            },
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }
}
