import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_widgets.dart';

class OrderCancelResult {
  const OrderCancelResult({required this.reason, required this.note});

  final String reason;
  final String note;
}

class OrderComplaintResult {
  const OrderComplaintResult({
    required this.message,
    required this.attachments,
  });

  final String message;
  final List<PlatformFile> attachments;
}

Future<OrderCancelResult?> showOrderCancelSheet({
  required BuildContext context,
  required String orderId,
  required OrderStatus status,
  required String total,
  required String initialNote,
}) async {
  const reasons = [
    'تأخر في تجهيز الطلب',
    'غيرت رأيي',
    'أريد تعديل الطلب',
    'طلبت بالخطأ',
    'السعر غير مناسب',
    'أخرى',
  ];
  String? selectedReason;
  final noteController = TextEditingController(text: initialNote);
  return showModalBottomSheet<OrderCancelResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => BottomSheetScaffold(
        title: 'إلغاء الطلب',
        subtitle: 'يرجى اختيار سبب الإلغاء قبل تأكيد الطلب',
        summary: OrderMiniCard(orderId: orderId, status: status, total: total),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'سبب الإلغاء',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: Spacing.sm),
            ...reasons.map(
              (reason) => CancelReasonTile(
                title: reason,
                selected: selectedReason == reason,
                onTap: () => setSheetState(() => selectedReason = reason),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SheetTextField(
              controller: noteController,
              hintText: 'اكتب ملاحظة إضافية (اختياري)...',
            ),
          ],
        ),
        secondaryActionLabel: 'تراجع',
        primaryActionLabel: 'تأكيد الإلغاء',
        primaryColor: AppColors.error,
        onSecondaryTap: () => Navigator.pop(context),
        onPrimaryTap: selectedReason == null
            ? null
            : () => Navigator.pop(
                context,
                OrderCancelResult(
                  reason: selectedReason!,
                  note: noteController.text.trim(),
                ),
              ),
      ),
    ),
  );
}

Future<OrderComplaintResult?> showOrderComplaintSheet({
  required BuildContext context,
  required String orderId,
  required OrderStatus status,
  required String total,
}) {
  final controller = TextEditingController();
  List<PlatformFile> attachments = [];
  return showModalBottomSheet<OrderComplaintResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) => BottomSheetScaffold(
        title: 'تقديم شكوى',
        subtitle: 'اكتب تفاصيل المشكلة وأرفق صورًا إن لزم',
        summary: OrderMiniCard(orderId: orderId, status: status, total: total),
        body: Column(
          children: [
            SheetTextField(
              controller: controller,
              hintText: 'اكتب تفاصيل الشكوى',
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
                      ? 'إرفاق صور'
                      : 'تم إرفاق ${attachments.length} صورة',
                ),
              ),
            ),
            if (attachments.isNotEmpty) ...[
              const SizedBox(height: Spacing.sm),
              ComplaintAttachmentsPreview(attachments: attachments),
            ],
          ],
        ),
        secondaryActionLabel: 'إلغاء',
        primaryActionLabel: 'إرسال',
        onSecondaryTap: () => Navigator.pop(context),
        onPrimaryTap: () {
          final value = controller.text.trim();
          if (value.isEmpty) return;
          Navigator.pop(
            context,
            OrderComplaintResult(message: value, attachments: attachments),
          );
        },
      ),
    ),
  );
}
