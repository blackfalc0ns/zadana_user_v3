import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class CustomSortOptionItem extends StatelessWidget {
  const CustomSortOptionItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.isSelected,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  static final RegExp _rtlTextPattern = RegExp(r'[\u0590-\u08FF]');

  bool _isRtlText(String value) {
    return _rtlTextPattern.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final textDirection = _isRtlText(title)
        ? TextDirection.rtl
        : TextDirection.ltr;
    final isRtl = textDirection == TextDirection.rtl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 54),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary.withValues(alpha: 0.04)
              : color.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color.primary.withValues(alpha: 0.5)
                : color.outlineVariant.withValues(alpha: 0.65),
          ),
        ),
        child: Directionality(
          textDirection: textDirection,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: isRtl
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size16,
                          color: color.onSurface,
                        ),
                      ),
                      if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          textAlign: isRtl ? TextAlign.right : TextAlign.left,
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
