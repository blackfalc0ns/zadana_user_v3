import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/support_case/support_case_formatters.dart';

class SupportCaseMessageTile extends StatelessWidget {
  const SupportCaseMessageTile({
    super.key,
    required this.title,
    required this.body,
    required this.authorRole,
    required this.createdAt,
    required this.attachments,
    required this.onAttachmentTap,
  });

  final String title;
  final String body;
  final String authorRole;
  final String createdAt;
  final List<OrderSupportCaseAttachmentEntity> attachments;
  final ValueChanged<OrderSupportCaseAttachmentEntity> onAttachmentTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final byCustomer = authorRole.trim().toLowerCase() == 'customer';

    return DecoratedBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: (byCustomer ? colors.primary : colors.secondary)
                      .withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  byCustomer
                      ? Icons.person_outline_rounded
                      : Icons.support_agent,
                  size: 18,
                  color: byCustomer ? colors.primary : colors.secondary,
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
                    SecondaryText(
                      supportCaseActorLabel(l10n, byCustomer: byCustomer),
                    ),
                  ],
                ),
              ),
              SecondaryText(createdAt),
            ],
          ),
          if (body.trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Text(body),
          ],
          if (attachments.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: attachments
                  .map(
                    (attachment) => AttachmentChip(
                      fileName: attachment.fileName,
                      onTap: attachment.fileUrl.trim().isEmpty
                          ? null
                          : () => onAttachmentTap(attachment),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}
