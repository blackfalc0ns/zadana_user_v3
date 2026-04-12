import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class VendorPromptCard extends StatelessWidget {
  const VendorPromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('select_prompt'),
      width: double.infinity,
      child: Row(
        children: [
          _buildStoreIcon(context),
          const SizedBox(width: 12),
          Expanded(child: _buildPromptText(context)),
          _buildTouchIcon(context),
        ],
      ),
    );
  }

  Widget _buildStoreIcon(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.primary.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Icon(Icons.store, color: color.primary, size: 20),
    );
  }

  Widget _buildPromptText(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.select_vendor_to_show_price,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          locale.select_vendors_to_compare,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTouchIcon(BuildContext context) {
    final color = context.colorScheme;

    return Icon(Icons.touch_app, color: color.primary, size: 24);
  }
}

