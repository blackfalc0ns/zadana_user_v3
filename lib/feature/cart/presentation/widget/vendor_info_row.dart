import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/cart_animations.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/animated_price_display.dart';
import 'package:zadana_user_v3/feature/cart/presentation/widget/vendor_selector.dart';

class VendorInfoRow extends StatelessWidget {
  final String selectedVendorId;
  final String selectedVendorName;
  final int itemsCount;
  final double totalPrice;
  final CartAnimations animations;

  const VendorInfoRow({
    super.key,
    required this.selectedVendorId,
    required this.selectedVendorName,
    required this.itemsCount,
    required this.totalPrice,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildVendorInfo(),
        const Spacer(),
        AnimatedPriceDisplay(
          totalPrice: totalPrice,
          animations: animations,
        ),
      ],
    );
  }

  Widget _buildVendorInfo() {
    return Row(
      children: [
        _buildVendorEmoji(),
        const SizedBox(width: 5),
        _buildVendorDetails(),
      ],
    );
  }

  Widget _buildVendorEmoji() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        dummyVendors.firstWhere((v) => v.id == selectedVendorId).emoji,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildVendorDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedVendorName,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          '$itemsCount منتج',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}