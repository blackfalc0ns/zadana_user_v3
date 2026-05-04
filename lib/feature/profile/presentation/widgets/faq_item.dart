import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

/// FAQ item widget
class FAQItem extends StatefulWidget {
  const FAQItem({super.key, required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.md),
        border: Border.all(
          color: _isExpanded
              ? color.primary.withValues(alpha: 0.28)
              : color.outline.withValues(alpha: 0.3),
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: color.primary.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Spacing.md),
          onTap: _toggleExpanded,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.help_outline, size: 18, color: color.primary),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        widget.question,
                        style: getBoldStyle(
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: Spacing.sm),
                    child: Text(
                      widget.answer,
                      style: getMediumStyle(
                        fontSize: FontSize.size13,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurfaceVariant,
                      ).copyWith(height: 1.6),
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 220),
                  sizeCurve: Curves.easeOutCubic,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
