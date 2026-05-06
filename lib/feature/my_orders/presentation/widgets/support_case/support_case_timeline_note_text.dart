import 'package:flutter/material.dart';

class SupportCaseTimelineNoteText extends StatelessWidget {
  const SupportCaseTimelineNoteText(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        color: colors.onSurface,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }
}
