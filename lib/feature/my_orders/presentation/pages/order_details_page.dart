import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_sheets.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_widgets.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.order});

  final OrderUiModel order;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late OrderStatus _status;
  OrderComplaintState _complaint = OrderComplaintState.none;
  String _message = '';
  String? _cancelReason;
  List<PlatformFile> _attachments = [];

  @override
  void initState() {
    super.initState();
    _status = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total =
        '${widget.order.totalPrice.toStringAsFixed(2)} ${l10n.currency}';
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: const CustomAppBar(title: 'تفاصيل الطلب', showShadow: false),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.base),
        children: [
          OrderHeaderCard(
            orderId: widget.order.id,
            status: _status,
            date: _date(widget.order.createdAt),
            itemCount: widget.order.itemsCount,
            total: total,
          ),
          const SizedBox(height: Spacing.base),
          DetailSection(
            title: 'ملخص الطلب',
            child: OrderSummaryGrid(
              itemCount: widget.order.itemsCount,
              subtotal: total,
              shipping: 'مجاني',
              total: total,
            ),
          ),
          const SizedBox(height: Spacing.base),

          // Delivery OTP Section - More Prominent
          DetailSection(
            title: 'رمز التسليم',
            child: Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.verified_user,
                          color: colors.onPrimary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'رمز التحقق OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'اضغط لعرض رمز التحقق عند استلام الطلب',
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.deliveryOtp,
                      ),
                      icon: const Icon(Icons.visibility_outlined, size: 20),
                      label: const Text(
                        'عرض رمز OTP',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.base),
          DetailSection(
            title: 'المنتجات',
            child: Column(
              children: widget.order.items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.sm),
                      child: OrderItemTile(
                        name: item.name,
                        quantity: item.quantity,
                        price:
                            '${item.price.toStringAsFixed(2)} ${l10n.currency}',
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (_complaint != OrderComplaintState.none) ...[
            const SizedBox(height: Spacing.base),
            DetailSection(
              title: 'حالة الشكوى',
              child: ComplaintStatusCard(
                title: complaintStatusLabel(_complaint),
                message: _message,
                attachments: _attachments,
              ),
            ),
          ],
          const SizedBox(height: Spacing.lg),
          OrderDetailsActions(
            canCancel: true,
            hasComplaint: _complaint != OrderComplaintState.none,
            onCancel: () => _cancel(context, total),
            onComplaint: () => _complaint == OrderComplaintState.none
                ? _submitComplaint(context, total)
                : _followComplaint(),
          ),

          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }

  Future<void> _cancel(BuildContext context, String total) async {
    final result = await showOrderCancelSheet(
      context: context,
      orderId: widget.order.id,
      status: _status,
      total: total,
      initialNote: _message,
    );
    if (result == null || !mounted) return;
    setState(() {
      _status = OrderStatus.cancelled;
      _message = result.note;
      _cancelReason = result.reason;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إلغاء الطلب بسبب: ${_cancelReason!}')),
    );
  }

  Future<void> _submitComplaint(BuildContext context, String total) async {
    final result = await showOrderComplaintSheet(
      context: context,
      orderId: widget.order.id,
      status: _status,
      total: total,
    );
    if (result == null || result.message.isEmpty || !mounted) return;
    setState(() {
      _message = result.message;
      _attachments = result.attachments;
      _complaint = OrderComplaintState.submitted;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم إرسال الشكوى')));
  }

  void _followComplaint() => setState(
    () => _complaint = _complaint == OrderComplaintState.submitted
        ? OrderComplaintState.inReview
        : OrderComplaintState.resolved,
  );

  String _date(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
