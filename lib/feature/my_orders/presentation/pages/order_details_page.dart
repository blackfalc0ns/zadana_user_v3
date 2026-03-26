import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: const CustomAppBar(
        title: 'تفاصيل الطلب',
        showShadow: false,
      ),
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
            canCancel: _status.canCancel,
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
