import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/helpers/dialogue_utils.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_request_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/cancel_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/create_order_support_case_request_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/delete_order_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/retry_order_payment_response_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/cancel_order_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/delete_order_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_order_cancellation_reasons_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_order_details_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_order_support_reasons_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/retry_order_payment_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/utils/support_case_error_mapper.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_sheets.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';

@injectable
class OrderDetailsViewModel extends Cubit<OrderDetailsState> {
  OrderDetailsViewModel(
    this._getOrderDetailsUseCase,
    this._getOrderCancellationReasonsUseCase,
    this._getOrderSupportReasonsUseCase,
    this._cancelOrderUseCase,
    this._retryOrderPaymentUseCase,
    this._deleteOrderUseCase,
  ) : super(const OrderDetailsState());

  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final GetOrderCancellationReasonsUseCase _getOrderCancellationReasonsUseCase;
  final GetOrderSupportReasonsUseCase _getOrderSupportReasonsUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final RetryOrderPaymentUseCase _retryOrderPaymentUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;
  MyOrdersRepository get _repository => GetIt.instance<MyOrdersRepository>();
  NotificationsSignalRService get _notificationsSignalRService =>
      GetIt.instance<NotificationsSignalRService>();

  StreamSubscription<dynamic>? _supportCaseChangedSubscription;
  String? _orderId;

  Future<void> load(String orderId) async {
    _orderId = orderId;
    _bindRealtime(orderId);
    emit(
      state.copyWith(
        isLoading: true,
        isDeleted: false,
        refundStatus: null,
        clearFailure: true,
        feedbackMessage: null,
        isFeedbackError: false,
      ),
    );

    final result = await _getOrderDetailsUseCase(orderId);
    switch (result) {
      case ApiSuccessResult<OrderDetailsEntity>():
        final refundStatusResult = await _repository.getOrderRefundStatus(
          orderId,
        );
        final refundStatus = _resolveRefundStatus(
          order: result.data,
          result: refundStatusResult,
        );
        emit(
          state.copyWith(
            isLoading: false,
            order: result.data,
            refundStatus: refundStatus,
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
        emit(state.copyWith(isRetryingPayment: false, clearFailure: true));
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

  Future<String?> handleComplaintPressed(
    BuildContext context, {
    required String orderId,
    required OrderStatus fallbackStatus,
    required double fallbackTotalPrice,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final activeCase = state.order?.activeCase;
    if (activeCase != null) {
      return activeCase.id;
    }

    final resolvedStatus = resolveStatus(fallbackStatus);
    final availableReasons = await _ensureAvailableSupportReasons(
      resolvedStatus,
    );
    if (availableReasons == null || !context.mounted) {
      return null;
    }
    final complaintReasons = availableReasons.$1;
    final returnReasons = availableReasons.$2;

    final result = await showOrderSupportCaseSheet(
      context: context,
      status: resolvedStatus,
      total: _money(context, state.order?.totalPrice ?? fallbackTotalPrice),
      canCreateComplaint: _canCreateComplaint(resolvedStatus),
      canCreateReturnRequest: _canCreateReturnRequest(resolvedStatus),
      complaintReasons: complaintReasons,
      returnReasons: returnReasons,
    );

    if (result == null || !context.mounted) {
      return null;
    }

    emit(
      state.copyWith(
        isSubmittingSupportCase: true,
        clearFailure: true,
        feedbackMessage: null,
        isFeedbackError: false,
      ),
    );

    final uploadedAttachments = <OrderSupportCaseAttachmentEntity>[];
    for (final attachment in result.attachments) {
      final path = attachment.path;
      if (path == null || path.trim().isEmpty) {
        emit(
          state.copyWith(
            isSubmittingSupportCase: false,
            feedbackMessage: l10n.error_other_desc,
            isFeedbackError: true,
          ),
        );
        return null;
      }

      final uploadResult = await _repository.uploadOrderSupportCaseAttachment(
        orderId,
        path,
      );

      switch (uploadResult) {
        case ApiSuccessResult():
          uploadedAttachments.add(
            OrderSupportCaseAttachmentEntity(
              fileName: uploadResult.data.fileName,
              fileUrl: uploadResult.data.url,
            ),
          );
        case ApiErrorResult():
          emit(
            state.copyWith(
              isSubmittingSupportCase: false,
              feedbackMessage: uploadResult.failure.errorMessage,
              isFeedbackError: true,
            ),
          );
          return null;
      }
    }

    final createResult = await _repository.createOrderSupportCase(
      orderId,
      CreateOrderSupportCaseRequestEntity(
        type: result.type,
        reasonCode: result.reasonCode,
        message: result.message,
        attachments: uploadedAttachments,
      ),
    );

    switch (createResult) {
      case ApiSuccessResult():
        await load(orderId);
        emit(
          state.copyWith(
            isSubmittingSupportCase: false,
            feedbackMessage: l10n.my_orders_support_case_created,
            isFeedbackError: false,
          ),
        );
        return createResult.data.id;
      case ApiErrorResult():
        final errorMessage =
            SupportCaseErrorMapper.isKnownDisputeError(createResult.failure) &&
                context.mounted
            ? SupportCaseErrorMapper.resolveMessage(
                context,
                createResult.failure,
              )
            : createResult.failure.errorMessage;
        emit(
          state.copyWith(
            isSubmittingSupportCase: false,
            feedbackMessage: errorMessage,
            isFeedbackError: true,
          ),
        );
        return null;
    }
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

  Future<List<OrderSupportReasonEntity>?> _ensureSupportReasons(
    OrderSupportCaseType type,
  ) async {
    final cachedReasons = type == OrderSupportCaseType.returnRequest
        ? state.returnSupportReasons
        : state.complaintSupportReasons;
    if (cachedReasons.isNotEmpty) {
      return cachedReasons;
    }

    final result = await _getOrderSupportReasonsUseCase(type);
    switch (result) {
      case ApiSuccessResult<List<OrderSupportReasonEntity>>():
        if (type == OrderSupportCaseType.returnRequest) {
          emit(
            state.copyWith(
              returnSupportReasons: result.data,
              clearFailure: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              complaintSupportReasons: result.data,
              clearFailure: true,
            ),
          );
        }
        return result.data;
      case ApiErrorResult<List<OrderSupportReasonEntity>>():
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

  bool _canCreateComplaint(OrderStatus status) => status.canCreateComplaint;

  bool _canCreateReturnRequest(OrderStatus status) =>
      status.canCreateReturnRequest;

  OrderRefundStatusEntity? _resolveRefundStatus({
    required OrderDetailsEntity order,
    required ApiResult<OrderRefundStatusEntity> result,
  }) {
    final endpointStatus = switch (result) {
      ApiSuccessResult<OrderRefundStatusEntity>() => result.data,
      ApiErrorResult<OrderRefundStatusEntity>() => null,
    };

    final hasEndpointDisplayData =
        endpointStatus != null &&
        (endpointStatus.hasAnySupportStatus ||
            endpointStatus.settlementStatus !=
                OrderSupportSettlementStatus.unknown ||
            (endpointStatus.couponCode?.trim().isNotEmpty ?? false));
    if (hasEndpointDisplayData) {
      return endpointStatus;
    }

    final fallbackCase = order.activeCase;
    if (fallbackCase == null) {
      return endpointStatus;
    }

    return OrderRefundStatusEntity(
      hasActiveCase: fallbackCase.status.isOpen,
      caseStatus: fallbackCase.status == OrderSupportCaseStatus.unknown
          ? null
          : fallbackCase.status,
      caseType: fallbackCase.type == OrderSupportCaseType.unknown
          ? null
          : fallbackCase.type,
      requestedAmount: null,
      approvedAmount: null,
      refundMethod: null,
      compensationType: OrderSupportCompensationType.unknown,
      settlementStatus: OrderSupportSettlementStatus.unknown,
      couponCode: null,
      couponExpiresAt: null,
      couponRedeemed: false,
      refundStatus: fallbackCase.status == OrderSupportCaseStatus.unknown
          ? null
          : _supportCaseStatusApiValue(fallbackCase.status),
      customerNote: fallbackCase.message.trim().isEmpty
          ? null
          : fallbackCase.message,
      refundLifecycleStatus: OrderRefundLifecycleStatus.notApplicable,
      refundProvider: null,
      refundFailureMessage: null,
    );
  }

  String _supportCaseStatusApiValue(OrderSupportCaseStatus status) {
    switch (status) {
      case OrderSupportCaseStatus.submitted:
        return 'submitted';
      case OrderSupportCaseStatus.inReview:
        return 'in_review';
      case OrderSupportCaseStatus.awaitingCustomerEvidence:
        return 'awaiting_customer_evidence';
      case OrderSupportCaseStatus.approved:
        return 'approved';
      case OrderSupportCaseStatus.rejected:
        return 'rejected';
      case OrderSupportCaseStatus.resolved:
        return 'resolved';
      case OrderSupportCaseStatus.unknown:
        return '';
    }
  }

  Future<(List<OrderSupportReasonEntity>, List<OrderSupportReasonEntity>)?>
  _ensureAvailableSupportReasons(OrderStatus status) async {
    var complaintReasons = state.complaintSupportReasons;
    var returnReasons = state.returnSupportReasons;

    if (_canCreateComplaint(status)) {
      final result = await _ensureSupportReasons(
        OrderSupportCaseType.complaint,
      );
      if (result == null) {
        return null;
      }
      complaintReasons = result;
    }

    if (_canCreateReturnRequest(status)) {
      final result = await _ensureSupportReasons(
        OrderSupportCaseType.returnRequest,
      );
      if (result == null) {
        return null;
      }
      returnReasons = result;
    }

    return (complaintReasons, returnReasons);
  }

  void _bindRealtime(String orderId) {
    _supportCaseChangedSubscription ??= _notificationsSignalRService
        .watchOrderSupportCaseChangedEvents()
        .listen((payload) {
          if (payload.orderId.trim().toLowerCase() !=
              (_orderId ?? '').trim().toLowerCase()) {
            return;
          }
          unawaited(load(_orderId!));
        });
  }

  @override
  Future<void> close() async {
    await _supportCaseChangedSubscription?.cancel();
    return super.close();
  }
}
