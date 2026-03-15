import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class VendorPromptCard extends StatelessWidget {
  const VendorPromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('select_prompt'),
      width: double.infinity,
      child: Row(
        children: [
          _buildStoreIcon(),
          const SizedBox(width: 12),
          Expanded(child: _buildPromptText()),
          _buildTouchIcon(),
        ],
      ),
    );
  }

  Widget _buildStoreIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Icon(Icons.store, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildPromptText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر متجر لعرض الأسعار',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'اختر من المتاجر أعلاه لمشاهدة أسعار المنتجات والمتابعة للدفع',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTouchIcon() {
    return Icon(Icons.touch_app, color: AppColors.primary, size: 24);
  }
}