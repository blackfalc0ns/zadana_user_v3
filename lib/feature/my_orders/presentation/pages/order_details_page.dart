import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_page/order_details_delete_action.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_page/order_details_page_content.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_page/order_details_page_flow.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, this.order, this.orderId})
    : assert(order != null || orderId != null);

  final OrderUiModel? order;
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final targetOrderId = order?.id ?? orderId!;
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    const flow = OrderDetailsPageFlow();

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: CustomAppBar(
        title: l10n.my_orders_details_title,
        showShadow: false,
        actions: [OrderDetailsDeleteAction(targetOrderId: targetOrderId)],
      ),
      body: OrderDetailsPageContent(
        targetOrderId: targetOrderId,
        fallbackOrder: order,
        flow: flow,
      ),
    );
  }
}
