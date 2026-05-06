import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_reason_entity.dart';
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

class OrderSupportCaseResult {
  const OrderSupportCaseResult({
    required this.type,
    required this.reasonCode,
    required this.message,
    required this.attachments,
  });

  final OrderSupportCaseType type;
  final String reasonCode;
  final String message;
  final List<PlatformFile> attachments;
}

class OrderSupportMessageResult {
  const OrderSupportMessageResult({
    required this.message,
    required this.attachments,
  });

  final String message;
  final List<PlatformFile> attachments;
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

Future<OrderSupportCaseResult?> showOrderSupportCaseSheet({
  required BuildContext context,
  required OrderStatus status,
  required String total,
  required bool canCreateComplaint,
  required bool canCreateReturnRequest,
  required List<OrderSupportReasonEntity> complaintReasons,
  required List<OrderSupportReasonEntity> returnReasons,
}) {
  final l10n = AppLocalizations.of(context)!;
  final languageCode = Localizations.localeOf(context).languageCode;
  final controller = TextEditingController();
  List<PlatformFile> attachments = [];
  OrderSupportCaseType selectedType = canCreateReturnRequest
      ? OrderSupportCaseType.returnRequest
      : OrderSupportCaseType.complaint;
  OrderSupportReasonEntity? selectedReason;

  return showModalBottomSheet<OrderSupportCaseResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => BottomSheetScaffold(
        title: l10n.my_orders_support_case_sheet_title,
        subtitle: l10n.my_orders_support_case_sheet_subtitle,
        summary: OrderMiniCard(status: status, total: total),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canCreateComplaint && canCreateReturnRequest) ...[
              Row(
                children: [
                  Expanded(
                    child: CancelReasonTile(
                      title: l10n.my_orders_support_case_type_complaint,
                      selected: selectedType == OrderSupportCaseType.complaint,
                      onTap: () => setSheetState(() {
                        selectedType = OrderSupportCaseType.complaint;
                        selectedReason = null;
                        controller.clear();
                      }),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: CancelReasonTile(
                      title: l10n.my_orders_support_case_type_return_request,
                      selected:
                          selectedType == OrderSupportCaseType.returnRequest,
                      onTap: () => setSheetState(() {
                        selectedType = OrderSupportCaseType.returnRequest;
                        selectedReason = null;
                        controller.clear();
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
            ],
            DropdownButtonFormField<String>(
              initialValue: selectedReason?.code,
              hint: Text(l10n.my_orders_support_case_reason_label),
              decoration: InputDecoration(
                labelText: l10n.my_orders_support_case_reason_label,
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: .12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: .28),
                  ),
                ),
              ),
              items:
                  (selectedType == OrderSupportCaseType.returnRequest
                          ? returnReasons
                          : complaintReasons)
                      .map(
                        (reason) => DropdownMenuItem(
                          value: reason.code,
                          child: Text(
                            reason.labelForLanguageCode(languageCode),
                          ),
                        ),
                      )
                      .toList(growable: false),
              onChanged: (value) {
                if (value == null) return;
                final reasons =
                    selectedType == OrderSupportCaseType.returnRequest
                    ? returnReasons
                    : complaintReasons;
                setSheetState(() {
                  selectedReason = reasons.firstWhere(
                    (reason) => reason.code == value,
                  );
                  controller.clear();
                });
              },
            ),
            const SizedBox(height: Spacing.md),
            SheetTextField(
              controller: controller,
              hintText: l10n.my_orders_support_case_sheet_hint,
              maxLines: 5,
              onChanged: (_) => setSheetState(() {}),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    withData: true,
                  );
                  if (result == null) return;
                  setSheetState(() => attachments = result.files);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.image_outlined),
                label: Text(
                  attachments.isEmpty
                      ? l10n.my_orders_support_case_sheet_attach_files
                      : l10n.my_orders_support_case_sheet_attached_files(
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
        primaryActionLabel: l10n.my_orders_support_case_sheet_send,
        onSecondaryTap: () => Navigator.pop(context),
        onPrimaryTap:
            selectedReason == null ||
                (selectedReason!.requiresNote && controller.text.trim().isEmpty)
            ? null
            : () {
                final value = controller.text.trim();
                Navigator.pop(
                  context,
                  OrderSupportCaseResult(
                    type: selectedType,
                    reasonCode: selectedReason!.code,
                    message: value,
                    attachments: attachments,
                  ),
                );
              },
      ),
    ),
  );
}

Future<OrderSupportMessageResult?> showOrderSupportMessageSheet({
  required BuildContext context,
}) {
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final controller = TextEditingController();
  List<PlatformFile> attachments = [];

  return showModalBottomSheet<OrderSupportMessageResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => BottomSheetScaffold(
        title: isArabic ? 'إرسال متابعة' : 'Send update',
        subtitle: isArabic
            ? 'أضف رسالة أو مرفقًا جديدًا داخل الحالة.'
            : 'Add a message or new attachment to this case.',
        summary: const SizedBox.shrink(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetTextField(
              controller: controller,
              hintText: isArabic
                  ? 'اكتب رسالتك هنا'
                  : 'Write your message here',
              maxLines: 5,
              onChanged: (_) => setSheetState(() {}),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    withData: true,
                  );
                  if (result == null) return;
                  setSheetState(() => attachments = result.files);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.attach_file_rounded),
                label: Text(
                  attachments.isEmpty
                      ? (isArabic ? 'إرفاق ملفات' : 'Attach files')
                      : (isArabic
                            ? 'تم إرفاق ${attachments.length} ملف'
                            : '${attachments.length} file(s) attached'),
                ),
              ),
            ),
            if (attachments.isNotEmpty) ...[
              const SizedBox(height: Spacing.sm),
              ComplaintAttachmentsPreview(attachments: attachments),
            ],
          ],
        ),
        secondaryActionLabel: isArabic ? 'إلغاء' : 'Cancel',
        primaryActionLabel: isArabic ? 'إرسال' : 'Send',
        onSecondaryTap: () => Navigator.pop(context),
        onPrimaryTap: controller.text.trim().isEmpty && attachments.isEmpty
            ? null
            : () => Navigator.pop(
                context,
                OrderSupportMessageResult(
                  message: controller.text.trim(),
                  attachments: attachments,
                ),
              ),
      ),
    ),
  );
}
