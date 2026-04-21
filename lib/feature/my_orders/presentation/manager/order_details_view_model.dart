import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_request_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/delete_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/cancel_order_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/delete_order_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_order_cancellation_reasons_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_order_details_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/retry_order_payment_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_shared.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_sheets.dart';

@injectable
class OrderDetailsViewModel extends Cubit<OrderDetailsState> {
  OrderDetailsViewModel(
    this._getOrderDetailsUseCase,
    this._getOrderCancellationReasonsUseCase,
    this._cancelOrderUseCase,
    this._retryOrderPaymentUseCase,
    this._deleteOrderUseCase,
  ) : super(const OrderDetailsState());

  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final GetOrderCancellationReasonsUseCase _getOrderCancellationReasonsUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final RetryOrderPaymentUseCase _retryOrderPaymentUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;

  Future<void> load(String orderId) async {
    emit(
      state.copyWith(
        isLoading: true,
        isDeleted: false,
        clearFailure: true,
        feedbackMessage: null,
        isFeedbackError: false,
      ),
    );

    final result = await _getOrderDetailsUseCase(orderId);
    switch (result) {
      case ApiSuccessResult<OrderDetailsEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            order: result.data,
            status: result.data.status,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<OrderDetailsEntity>():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  void applyCancel(
    OrderCancelResult result,
    CancelOrderResponseEntity response,
  ) {
    emit(
      state.copyWith(
        isCancelling: false,
        status: response.order.status,
        cancelReason: result.reasonLabel,
        feedbackMessage: response.message,
        isFeedbackError: false,
        clearFailure: true,
      ),
    );
  }

  void submitComplaint(OrderComplaintResult result) {
    emit(
      state.copyWith(
        message: result.message,
        attachments: result.attachments,
        complaint: OrderComplaintState.submitted,
        feedbackMessage: result.feedbackMessage,
        isFeedbackError: false,
      ),
    );
  }

  void followComplaint() {
    final nextComplaint = state.complaint == OrderComplaintState.submitted
        ? OrderComplaintState.inReview
        : OrderComplaintState.resolved;

    emit(state.copyWith(complaint: nextComplaint));
  }

  void clearFeedback() {
    if (state.feedbackMessage == null) return;
    emit(state.copyWith(feedbackMessage: null));
  }

  Future<RetryOrderPaymentEntity?> retryPayment(String orderId) async {
    if (state.isRetryingPayment) return null;

    emit(
      state.copyWith(
        isRetryingPayment: true,
        clearFailure: true,
        feedbackMessage: null,
        isFeedbackError: false,
      ),
    );

    final result = await _retryOrderPaymentUseCase(orderId);
    switch (result) {
      case ApiSuccessResult<RetryOrderPaymentResponseEntity>():
        emit(
          state.copyWith(
            isRetryingPayment: false,
            clearFailure: true,
          ),
        );
        return result.data.payment;
      case ApiErrorResult<RetryOrderPaymentResponseEntity>():
        emit(
          state.copyWith(
            isRetryingPayment: false,
            feedbackMessage: result.failure.errorMessage,
            isFeedbackError: true,
          ),
        );
        return null;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    if (state.isDeleting) return;

    emit(
      state.copyWith(
        isDeleting: true,
        isDeleted: false,
        clearFailure: true,
        feedbackMessage: null,
        isFeedbackError: false,
      ),
    );

    final result = await _deleteOrderUseCase(orderId);
    switch (result) {
      case ApiSuccessResult<DeleteOrderResponseEntity>():
        emit(
          state.copyWith(
            isDeleting: false,
            isDeleted: result.data.deleted,
            feedbackMessage: result.data.message,
            isFeedbackError: false,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<DeleteOrderResponseEntity>():
        emit(
          state.copyWith(
            isDeleting: false,
            feedbackMessage: result.failure.errorMessage,
            isFeedbackError: true,
          ),
        );
    }
  }

  OrderStatus resolveStatus(OrderStatus fallbackStatus) {
    return state.status ?? state.order?.status ?? fallbackStatus;
  }

  List<PlatformFile> currentAttachments() => state.attachments;

  Future<void> handleCancelPressed(
    BuildContext context, {
    required String orderId,
    required OrderStatus fallbackStatus,
    required double fallbackTotalPrice,
  }) async {
    final reasons = await _ensureCancellationReasons();
    if (!context.mounted || reasons == null || reasons.isEmpty) {
      return;
    }

    final result = await showOrderCancelSheet(
      context: context,
      status: resolveStatus(fallbackStatus),
      total: _money(context, state.order?.totalPrice ?? fallbackTotalPrice),
      reasons: reasons,
      initialNote: '',
    );

    if (result == null || !context.mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await DialogueUtils.showCompactConfirmationDialog(
      context: context,
      title: l10n.my_orders_cancel_confirm_title,
      message: l10n.my_orders_cancel_confirm_message,
      confirmLabel: l10n.my_orders_cancel_sheet_confirm,
      cancelLabel: l10n.cancel,
      icon: Icons.error_outline_rounded,
      accentColor: Colors.redAccent,
    );

    if (!confirmed || !context.mounted) return;

    emit(
      state.copyWith(
        isCancelling: true,
        clearFailure: true,
        feedbackMessage: null,
        isFeedbackError: false,
      ),
    );

    final cancelResult = await _cancelOrderUseCase(
      orderId,
      CancelOrderRequestEntity(
        reasonCode: result.reasonCode,
        reason: result.reasonLabel,
        note: result.note,
      ),
    );

    switch (cancelResult) {
      case ApiSuccessResult<CancelOrderResponseEntity>():
        applyCancel(result, cancelResult.data);
      case ApiErrorResult<CancelOrderResponseEntity>():
        emit(
          state.copyWith(
            isCancelling: false,
            feedbackMessage: cancelResult.failure.errorMessage,
            isFeedbackError: true,
          ),
        );
    }
  }

  Future<void> handleComplaintPressed(
    BuildContext context, {
    required OrderStatus fallbackStatus,
    required double fallbackTotalPrice,
  }) async {
    if (state.complaint != OrderComplaintState.none) {
      followComplaint();
      return;
    }

    final result = await showOrderComplaintSheet(
      context: context,
      status: resolveStatus(fallbackStatus),
      total: _money(context, state.order?.totalPrice ?? fallbackTotalPrice),
    );

    if (result == null || result.message.isEmpty || !context.mounted) return;
    submitComplaint(result);
  }

  Future<List<OrderCancellationReasonEntity>?>
  _ensureCancellationReasons() async {
    if (state.cancellationReasons.isNotEmpty) {
      return state.cancellationReasons;
    }

    final result = await _getOrderCancellationReasonsUseCase();
    switch (result) {
      case ApiSuccessResult<List<OrderCancellationReasonEntity>>():
        emit(
          state.copyWith(cancellationReasons: result.data, clearFailure: true),
        );
        return result.data;
      case ApiErrorResult<List<OrderCancellationReasonEntity>>():
        emit(
          state.copyWith(
            feedbackMessage: result.failure.errorMessage,
            isFeedbackError: true,
          ),
        );
        return null;
    }
  }

  String _money(BuildContext context, double value) {
    final l10n = AppLocalizations.of(context)!;
    return '${value.toStringAsFixed(2)} ${l10n.currency}';
  }
}
