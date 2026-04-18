import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_body_view.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_loading_view.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, this.order, this.orderId})
    : assert(order != null || orderId != null);

  final OrderUiModel? order;
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: CustomAppBar(
        title: l10n.my_orders_details_title,
        showShadow: false,
      ),
      body: BlocConsumer<OrderDetailsViewModel, OrderDetailsState>(
        listenWhen: (previous, current) =>
            previous.feedbackMessage != current.feedbackMessage,
        listener: (context, state) {
          final feedback = state.feedbackMessage;
          if (feedback == null) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(feedback)));
          context.read<OrderDetailsViewModel>().clearFeedback();
        },
        builder: (context, state) {
          final targetOrderId = order?.id ?? orderId!;
          if (state.isLoading && state.order == null) {
            return const OrderDetailsLoadingView();
          }

          if (state.failure != null && state.order == null) {
            return ApiErrorWidget.fromFailure(
              state.failure!,
              onRetry: () => context.read<OrderDetailsViewModel>().load(targetOrderId),
            );
          }

          final orderDetails = state.order;
          if (orderDetails == null) {
            return const SizedBox.shrink();
          }

          return OrderDetailsBodyView(
            order: orderDetails,
            complaint: state.complaint,
            message: state.message,
            attachments: state.attachments,
            status: state.status ?? orderDetails.status,
            onCancel: () =>
                context.read<OrderDetailsViewModel>().handleCancelPressed(
                  context,
                  fallbackStatus: order?.status ?? orderDetails.status,
                  fallbackTotalPrice: order?.totalPrice ?? orderDetails.totalPrice,
                ),
            onComplaint: () =>
                context.read<OrderDetailsViewModel>().handleComplaintPressed(
                  context,
                  fallbackStatus: order?.status ?? orderDetails.status,
                  fallbackTotalPrice: order?.totalPrice ?? orderDetails.totalPrice,
                ),
          );
        },
      ),
    );
  }
}
