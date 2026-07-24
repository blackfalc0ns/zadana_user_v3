import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';

class LegalDocumentView extends StatelessWidget {
  const LegalDocumentView({
    super.key,
    required this.content,
    required this.textDirection,
  });

  final String content;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final lines = content
        .split('\n')
        .where((line) => !line.trimLeft().startsWith('>'))
        .toList();

    return Directionality(
      textDirection: textDirection,
      child: ListView.builder(
        padding: const EdgeInsets.all(Spacing.lg),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index].trim();
          if (line.isEmpty || line == '---') {
            return const SizedBox(height: Spacing.sm);
          }
          final isTitle = line.startsWith('# ');
          final isHeading = line.startsWith('## ');
          final text = line
              .replaceFirst(RegExp(r'^#{1,2}\s*'), '')
              .replaceAll('**', '')
              .replaceAll('`', '');
          return Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: SelectableText(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: isTitle || isHeading
                    ? color.onSurface
                    : color.onSurfaceVariant,
                fontSize: isTitle ? 22 : (isHeading ? 18 : 14),
                fontWeight: isTitle || isHeading
                    ? FontWeight.w700
                    : FontWeight.w400,
                height: 1.7,
              ),
            ),
          );
        },
      ),
    );
  }
}
