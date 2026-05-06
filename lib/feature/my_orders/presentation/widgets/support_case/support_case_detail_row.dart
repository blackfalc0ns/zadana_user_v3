import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';

class SupportCaseDetailRow extends StatelessWidget {
  const SupportCaseDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 4,
          child: Text(
            label,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: Spacing.base),
        Flexible(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: getBoldStyle(
              fontSize: FontSize.size14,
              color: valueColor ?? colors.onSurface,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
      ],
    );
  }
}
