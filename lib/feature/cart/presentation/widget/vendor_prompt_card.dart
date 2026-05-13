import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class VendorPromptCard extends StatelessWidget {
  const VendorPromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('select_prompt'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.primaryLight.withValues(alpha: 0.06),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.24),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStoreIcon(context),
              const SizedBox(width: 10),
              Expanded(child: _buildPromptText(context)),
              _buildTouchIcon(context),
            ],
          ),
          const SizedBox(height: 4),
          // Row(
          //   children: [
          //     const Spacer(),
          //     Icon(
          //       Icons.keyboard_double_arrow_down_rounded,
          //       color: AppColors.primary.withValues(alpha: 0.72),
          //       size: 16,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildStoreIcon(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Icon(Icons.storefront_rounded, color: color.primary, size: 18),
    );
  }

  Widget _buildPromptText(BuildContext context) {
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        //   decoration: BoxDecoration(
        //     color: Colors.white.withValues(alpha: 0.7),
        //     borderRadius: BorderRadius.circular(999),
        //   ),
        //   child: Text(
        //     locale.compare,
        //     style: getBoldStyle(
        //       fontFamily: FontConstant.cairo,
        //       fontSize: FontSize.size9,
        //       color: AppColors.primary,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 4),
        Text(
          locale.select_vendor_to_show_price,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size15,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          locale.select_vendors_to_compare,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTouchIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.touch_app_rounded,
        color: context.colorScheme.primary,
        size: 19,
      ),
    );
  }
}
