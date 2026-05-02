import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/core/widgets/custom_snackbar.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_view_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/pages/order_support_case_page.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_body_view.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_loading_view.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/payment/presentation/pages/payment_webview_screen.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, this.order, this.orderId})
    : assert(order != null || orderId != null);

  static const String _paymentStatusSuccess = 'success';
  static const String _paymentStatusFailed = 'failed';
  static const String _paymentStatusPending = 'pending';

  final OrderUiModel? order;
  final String? orderId;

  Future<void> _handleRetryPayment(
    BuildContext context,
    String targetOrderId,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final payment = await context.read<OrderDetailsViewModel>().retryPayment(
      targetOrderId,
    );
    if (!context.mounted || payment == null) {
      return;
    }

    final paymentUrl = payment.iframeUrl.trim();
    if (paymentUrl.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: l10n.error_other_desc,
      );
      return;
    }

    final paymentResult = await Navigator.push<PaymentCallbackResult>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebViewScreen(paymentUrl: paymentUrl),
      ),
    );

    if (!context.mounted) return;
    await _handlePaymentCallbackResult(
      context: context,
      result: paymentResult,
      fallbackErrorMessage: l10n.error_other_desc,
      pendingMessage: l10n.order_pending,
      fallbackOrderId: targetOrderId,
    );
  }

  Future<void> _handlePaymentCallbackResult({
    required BuildContext context,
    required PaymentCallbackResult? result,
    required String fallbackErrorMessage,
    required String pendingMessage,
    required String fallbackOrderId,
  }) async {
    if (result == null) {
      return;
    }

    final paymentStatus = _resolvePaymentCallbackStatus(result);
    final paymentMessage = result['message'];
    final orderId = result['orderId'] ?? fallbackOrderId;

    if (paymentStatus == _paymentStatusFailed) {
      CustomSnackbar.showError(
        context: context,
        message: paymentMessage ?? fallbackErrorMessage,
      );
      return;
    }

    if (paymentStatus == _paymentStatusPending) {
      CustomSnackbar.showInfo(
        context: context,
        message: paymentMessage ?? pendingMessage,
      );
      return;
    }

    if (paymentStatus == _paymentStatusSuccess && orderId.isNotEmpty) {
      await Navigator.of(
        context,
      ).pushReplacementNamed(AppRoutes.paymentSuccess, arguments: orderId);
      return;
    }

    CustomSnackbar.showError(
      context: context,
      message: paymentMessage ?? fallbackErrorMessage,
    );
  }

  void _openTracking(BuildContext context, String targetOrderId) {
    Navigator.pushNamed(
      context,
      AppRoutes.trackOrder,
      arguments: targetOrderId,
    );
  }

  Future<void> _openSupportCases(
    BuildContext context,
    String targetOrderId, {
    String? caseId,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => OrderSupportCaseViewModel(
            getIt<MyOrdersRepository>(),
            getIt<NotificationsSignalRService>(),
          )..initialize(targetOrderId, initialCaseId: caseId),
          child: OrderSupportCasePage(
            orderId: targetOrderId,
            initialCaseId: caseId,
          ),
        ),
      ),
    );

    if (context.mounted) {
      await context.read<OrderDetailsViewModel>().load(targetOrderId);
    }
  }

  String? _resolvePaymentCallbackStatus(PaymentCallbackResult result) {
    final directStatus = result['status']?.trim().toLowerCase();
    if (directStatus == _paymentStatusSuccess ||
        directStatus == _paymentStatusFailed ||
        directStatus == _paymentStatusPending) {
      return directStatus;
    }

    final rawPaymentStatus = result['paymentStatus']?.trim().toLowerCase();
    if (rawPaymentStatus == 'paid' ||
        rawPaymentStatus == 'success' ||
        rawPaymentStatus == 'succeeded') {
      return _paymentStatusSuccess;
    }

    if (rawPaymentStatus == 'failed' ||
        rawPaymentStatus == 'unpaid' ||
        rawPaymentStatus == 'canceled' ||
        rawPaymentStatus == 'cancelled') {
      return _paymentStatusFailed;
    }

    if (rawPaymentStatus == 'pending' || rawPaymentStatus == 'processing') {
      return _paymentStatusPending;
    }

    final orderStatus = result['orderStatus']?.trim().toLowerCase();
    if (orderStatus?.contains('pending') ?? false) {
      return _paymentStatusPending;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final targetOrderId = order?.id ?? orderId!;
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: CustomAppBar(
        title: l10n.my_orders_details_title,
        showShadow: false,
        actions: [
          BlocBuilder<OrderDetailsViewModel, OrderDetailsState>(
            buildWhen: (previous, current) =>
                previous.isDeleting != current.isDeleting ||
                previous.order?.canDelete != current.order?.canDelete,
            builder: (context, state) {
              if (!(state.order?.canDelete ?? false)) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: IconButton(
                  tooltip: l10n.delete,
                  onPressed: state.isDeleting
                      ? null
                      : () async {
                          final confirmed =
                              await DialogueUtils.showCompactConfirmationDialog(
                                context: context,
                                title: l10n.my_orders_delete_title,
                                message: l10n.my_orders_delete_message,
                                confirmLabel: l10n.delete,
                                cancelLabel: l10n.cancel,
                                icon: Icons.delete_outline_rounded,
                                accentColor: AppColors.error,
                                barrierDismissible: !state.isDeleting,
                              );

                          if (!confirmed || !context.mounted) return;
                          await context
                              .read<OrderDetailsViewModel>()
                              .deleteOrder(targetOrderId);
                        },
                  icon: state.isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<OrderDetailsViewModel, OrderDetailsState>(
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
            status: state.status ?? orderDetails.status,
            isBusy: state.isLoading,
            isCancelling: state.isCancelling,
            isRetryingPayment: state.isRetryingPayment,
            isDeleting: state.isDeleting,
            isSubmittingSupportCase: state.isSubmittingSupportCase,
            onTrackOrder: () => _openTracking(context, targetOrderId),
            onCancel: () =>
                context.read<OrderDetailsViewModel>().handleCancelPressed(
                  context,
                  orderId: targetOrderId,
                  fallbackStatus: order?.status ?? orderDetails.status,
                  fallbackTotalPrice:
                      order?.totalPrice ?? orderDetails.totalPrice,
                ),
            onRetryPayment: () => _handleRetryPayment(context, targetOrderId),
            onSupportCase: () async {
              final activeCaseId = orderDetails.activeCase?.id;
              if (activeCaseId != null && activeCaseId.isNotEmpty) {
                await _openSupportCases(
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
                    fallbackStatus: order?.status ?? orderDetails.status,
                    fallbackTotalPrice:
                        order?.totalPrice ?? orderDetails.totalPrice,
                  );
              if (!context.mounted || createdCaseId == null) return;
              await _openSupportCases(
                context,
                targetOrderId,
                caseId: createdCaseId,
              );
            },
          );
        },
      ),
    );
  }
}
