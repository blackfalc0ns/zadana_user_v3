import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_primitives.dart';

class OrderCancelResult {
  const OrderCancelResult({
    required this.reasonCode,
    required this.reasonLabel,
    required this.note,
  });

  final String reasonCode;
  final String reasonLabel;
  final String note;
}

class OrderComplaintResult {
  const OrderComplaintResult({
    required this.message,
    required this.attachments,
    required this.feedbackMessage,
  });

  final String message;
  final List<PlatformFile> attachments;
  final String feedbackMessage;
}

Future<OrderCancelResult?> showOrderCancelSheet({
  required BuildContext context,
  required OrderStatus status,
  required String total,
  required List<OrderCancellationReasonEntity> reasons,
  required String initialNote,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final languageCode = Localizations.localeOf(context).languageCode;
  OrderCancellationReasonEntity? selectedReason;
  final noteController = TextEditingController(text: initialNote);

  return showModalBottomSheet<OrderCancelResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => BottomSheetScaffold(
        title: l10n.my_orders_cancel_sheet_title,
        subtitle: l10n.my_orders_cancel_sheet_subtitle,
        summary: OrderMiniCard(status: status, total: total),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.my_orders_cancel_sheet_reason_label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: Spacing.sm),
            ...reasons.map(
              (reason) => CancelReasonTile(
                title: reason.labelForLanguageCode(languageCode),
                selected: selectedReason == reason,
                onTap: () => setSheetState(() => selectedReason = reason),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SheetTextField(
              controller: noteController,
              hintText: l10n.my_orders_cancel_sheet_note_hint,
              onChanged: (_) => setSheetState(() {}),
            ),
          ],
        ),
        secondaryActionLabel: l10n.my_orders_cancel_sheet_back,
        primaryActionLabel: l10n.my_orders_cancel_sheet_confirm,
        primaryColor: AppColors.error,
        onSecondaryTap: () => Navigator.pop(context),
        onPrimaryTap:
            selectedReason == null ||
                (selectedReason!.requiresNote &&
                    noteController.text.trim().isEmpty)
            ? null
            : () => Navigator.pop(
                context,
                OrderCancelResult(
                  reasonCode: selectedReason!.code,
                  reasonLabel: selectedReason!.labelForLanguageCode(
                    languageCode,
                  ),
                  note: noteController.text.trim(),
                ),
              ),
      ),
    ),
  );
}

Future<OrderComplaintResult?> showOrderComplaintSheet({
  required BuildContext context,
  required OrderStatus status,
  required String total,
}) {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();
  List<PlatformFile> attachments = [];

  return showModalBottomSheet<OrderComplaintResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => BottomSheetScaffold(
        title: l10n.my_orders_complaint_sheet_title,
        subtitle: l10n.my_orders_complaint_sheet_subtitle,
        summary: OrderMiniCard(status: status, total: total),
        body: Column(
          children: [
            SheetTextField(
              controller: controller,
              hintText: l10n.my_orders_complaint_sheet_hint,
              maxLines: 5,
            ),
            const SizedBox(height: Spacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: true,
                    withData: true,
                  );
                  if (result == null) return;
                  setSheetState(() => attachments = result.files);
                },
                icon: const Icon(Icons.image_outlined),
                label: Text(
                  attachments.isEmpty
                      ? l10n.my_orders_complaint_sheet_attach_images
                      : l10n.my_orders_complaint_sheet_attached_images(
                          attachments.length,
                        ),
                ),
              ),
            ),
            if (attachments.isNotEmpty) ...[
              const SizedBox(height: Spacing.sm),
              ComplaintAttachmentsPreview(attachments: attachments),
            ],
          ],
        ),
        secondaryActionLabel: l10n.cancel,
        primaryActionLabel: l10n.my_orders_complaint_sheet_send,
        onSecondaryTap: () => Navigator.pop(context),
        onPrimaryTap: () {
          final value = controller.text.trim();
          if (value.isEmpty) return;
          Navigator.pop(
            context,
            OrderComplaintResult(
              message: value,
              attachments: attachments,
              feedbackMessage: l10n.my_orders_complaint_submitted_feedback,
            ),
          );
        },
      ),
    ),
  );
}
