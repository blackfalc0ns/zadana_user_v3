import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_body_view.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_loading_view.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_page/order_details_page_flow.dart';

class OrderDetailsPageContent extends StatelessWidget {
  const OrderDetailsPageContent({
    super.key,
    required this.targetOrderId,
    required this.fallbackOrder,
    required this.flow,
  });

  final String targetOrderId;
  final OrderUiModel? fallbackOrder;
  final OrderDetailsPageFlow flow;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailsViewModel, OrderDetailsState>(
      listenWhen: (previous, current) =>
          previous.feedbackMessage != current.feedbackMessage ||
          previous.isDeleting != current.isDeleting ||
          previous.isDeleted != current.isDeleted,
      listener: (context, state) {
        if (!state.isDeleting && state.isDeleted) {
          final feedback = state.feedbackMessage;
          if (feedback != null && feedback.isNotEmpty) {
            CustomSnackbar.showSuccess(context: context, message: feedback);
          }
          Navigator.of(context).pop(true);
          return;
        }

        final feedback = state.feedbackMessage;
        if (feedback == null) return;

        if (state.isFeedbackError) {
          CustomSnackbar.showError(context: context, message: feedback);
        } else {
          CustomSnackbar.showSuccess(context: context, message: feedback);
        }
        context.read<OrderDetailsViewModel>().clearFeedback();
      },
      builder: (context, state) {
        if (state.isLoading && state.order == null) {
          return const OrderDetailsLoadingView();
        }

        if (state.failure != null && state.order == null) {
          return ApiErrorWidget(
            exception: state.failure!.exception,
            onRetry: () =>
                context.read<OrderDetailsViewModel>().load(targetOrderId),
          );
        }

        final orderDetails = state.order;
        if (orderDetails == null) {
          return const SizedBox.shrink();
        }

        return OrderDetailsBodyView(
          order: orderDetails,
          refundStatus: state.refundStatus,
          status: state.status ?? orderDetails.status,
          isBusy: state.isLoading,
          isCancelling: state.isCancelling,
          isRetryingPayment: state.isRetryingPayment,
          isDeleting: state.isDeleting,
          isSubmittingSupportCase: state.isSubmittingSupportCase,
          onTrackOrder: () => flow.openTracking(context, targetOrderId),
          onCancel: () =>
              context.read<OrderDetailsViewModel>().handleCancelPressed(
                context,
                orderId: targetOrderId,
                fallbackStatus: fallbackOrder?.status ?? orderDetails.status,
                fallbackTotalPrice:
                    fallbackOrder?.totalPrice ?? orderDetails.totalPrice,
              ),
          onRetryPayment: () => flow.retryPayment(context, targetOrderId),
          onSupportCase: () async {
            final activeCaseId = orderDetails.activeCase?.id;
            if (activeCaseId != null && activeCaseId.isNotEmpty) {
              await flow.openSupportCases(
                context,
                targetOrderId,
                caseId: activeCaseId,
              );
              return;
            }

            final createdCaseId = await context
                .read<OrderDetailsViewModel>()
                .handleComplaintPressed(
                  context,
                  orderId: targetOrderId,
                  fallbackStatus: fallbackOrder?.status ?? orderDetails.status,
                  fallbackTotalPrice:
                      fallbackOrder?.totalPrice ?? orderDetails.totalPrice,
                );
            if (!context.mounted || createdCaseId == null) return;
            await flow.openSupportCases(
              context,
              targetOrderId,
              caseId: createdCaseId,
            );
          },
        );
      },
    );
  }
}
