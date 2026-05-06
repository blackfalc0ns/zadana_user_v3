import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';

class OrderSupportCaseState {
  const OrderSupportCaseState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isCaseLoading = false,
    this.isSendingMessage = false,
    this.items = const [],
    this.selectedCase,
    this.selectedCaseId,
    this.failure,
    this.feedbackMessage,
    this.isFeedbackError = false,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isCaseLoading;
  final bool isSendingMessage;
  final List<OrderSupportCaseEntity> items;
  final OrderSupportCaseEntity? selectedCase;
  final String? selectedCaseId;
  final Failure? failure;
  final String? feedbackMessage;
  final bool isFeedbackError;

  OrderSupportCaseState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isCaseLoading,
    bool? isSendingMessage,
    List<OrderSupportCaseEntity>? items,
    Object? selectedCase = _unset,
    Object? selectedCaseId = _unset,
    Failure? failure,
    Object? feedbackMessage = _unset,
    bool? isFeedbackError,
    bool clearFailure = false,
  }) {
    return OrderSupportCaseState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isCaseLoading: isCaseLoading ?? this.isCaseLoading,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      items: items ?? this.items,
      selectedCase: identical(selectedCase, _unset)
          ? this.selectedCase
          : selectedCase as OrderSupportCaseEntity?,
      selectedCaseId: identical(selectedCaseId, _unset)
          ? this.selectedCaseId
          : selectedCaseId as String?,
      failure: clearFailure ? null : failure ?? this.failure,
      feedbackMessage: identical(feedbackMessage, _unset)
          ? this.feedbackMessage
          : feedbackMessage as String?,
      isFeedbackError: isFeedbackError ?? this.isFeedbackError,
    );
  }

  static const _unset = Object();
}
