import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_cancellation_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_reason_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';

class OrderDetailsState {
  const OrderDetailsState({
    this.isLoading = false,
    this.isCancelling = false,
    this.isRetryingPayment = false,
    this.isDeleting = false,
    this.isSubmittingSupportCase = false,
    this.isDeleted = false,
    this.order,
    this.failure,
    this.status,
    this.cancellationReasons = const [],
    this.complaintSupportReasons = const [],
    this.returnSupportReasons = const [],
    this.cancelReason,
    this.feedbackMessage,
    this.isFeedbackError = false,
  });

  static const _unset = Object();

  final bool isLoading;
  final bool isCancelling;
  final bool isRetryingPayment;
  final bool isDeleting;
  final bool isSubmittingSupportCase;
  final bool isDeleted;
  final OrderDetailsEntity? order;
  final Failure? failure;
  final OrderStatus? status;
  final List<OrderCancellationReasonEntity> cancellationReasons;
  final List<OrderSupportReasonEntity> complaintSupportReasons;
  final List<OrderSupportReasonEntity> returnSupportReasons;
  final String? cancelReason;
  final String? feedbackMessage;
  final bool isFeedbackError;

  OrderDetailsState copyWith({
    bool? isLoading,
    bool? isCancelling,
    bool? isRetryingPayment,
    bool? isDeleting,
    bool? isSubmittingSupportCase,
    bool? isDeleted,
    OrderDetailsEntity? order,
    Failure? failure,
    OrderStatus? status,
    List<OrderCancellationReasonEntity>? cancellationReasons,
    List<OrderSupportReasonEntity>? complaintSupportReasons,
    List<OrderSupportReasonEntity>? returnSupportReasons,
    Object? cancelReason = _unset,
    Object? feedbackMessage = _unset,
    bool? isFeedbackError,
    bool clearFailure = false,
    bool clearOrder = false,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      isRetryingPayment: isRetryingPayment ?? this.isRetryingPayment,
      isDeleting: isDeleting ?? this.isDeleting,
      isSubmittingSupportCase:
          isSubmittingSupportCase ?? this.isSubmittingSupportCase,
      isDeleted: isDeleted ?? this.isDeleted,
      order: clearOrder ? null : order ?? this.order,
      failure: clearFailure ? null : failure ?? this.failure,
      status: status ?? this.status,
      cancellationReasons: cancellationReasons ?? this.cancellationReasons,
      complaintSupportReasons:
          complaintSupportReasons ?? this.complaintSupportReasons,
      returnSupportReasons: returnSupportReasons ?? this.returnSupportReasons,
      cancelReason: identical(cancelReason, _unset)
          ? this.cancelReason
          : cancelReason as String?,
      feedbackMessage: identical(feedbackMessage, _unset)
          ? this.feedbackMessage
          : feedbackMessage as String?,
      isFeedbackError: isFeedbackError ?? this.isFeedbackError,
    );
  }
}
