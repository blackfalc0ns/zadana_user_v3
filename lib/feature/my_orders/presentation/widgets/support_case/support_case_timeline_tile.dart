import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_timeline_note_text.dart';

class SupportCaseTimelineTile extends StatelessWidget {
  const SupportCaseTimelineTile({
    super.key,
    required this.title,
    required this.note,
    required this.createdAt,
  });

  final String title;
  final String note;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBlock(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 20,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  SupportCaseTimelineNoteText(note),
                ],
                const SizedBox(height: 4),
                SecondaryText(createdAt),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
