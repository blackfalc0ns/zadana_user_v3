import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

Future<void> showSupportCaseAttachmentPreview(
  BuildContext context,
  String fileName,
  String fileUrl,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final colors = Theme.of(dialogContext).colorScheme;
      final l10n = AppLocalizations.of(dialogContext)!;

      return Dialog(
        insetPadding: const EdgeInsets.all(Spacing.base),
        backgroundColor: colors.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.base,
                Spacing.base,
                Spacing.sm,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Flexible(
              child: InteractiveViewer(
                maxScale: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.base,
                    0,
                    Spacing.base,
                    Spacing.base,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      fileUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 280,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          height: 220,
                          child: Center(
                            child: Text(
                              l10n.my_orders_support_case_preview_image_error,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
