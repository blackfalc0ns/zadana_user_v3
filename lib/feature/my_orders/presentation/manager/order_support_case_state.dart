import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';

class OrderSupportCaseState {
  const OrderSupportCaseState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isCaseLoading = false,
    this.items = const [],
    this.selectedCase,
    this.selectedCaseId,
    this.failure,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isCaseLoading;
  final List<OrderSupportCaseEntity> items;
  final OrderSupportCaseEntity? selectedCase;
  final String? selectedCaseId;
  final Failure? failure;

  OrderSupportCaseState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isCaseLoading,
    List<OrderSupportCaseEntity>? items,
    Object? selectedCase = _unset,
    Object? selectedCaseId = _unset,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return OrderSupportCaseState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isCaseLoading: isCaseLoading ?? this.isCaseLoading,
      items: items ?? this.items,
      selectedCase: identical(selectedCase, _unset)
          ? this.selectedCase
          : selectedCase as OrderSupportCaseEntity?,
      selectedCaseId: identical(selectedCaseId, _unset)
          ? this.selectedCaseId
          : selectedCaseId as String?,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  static const _unset = Object();
}
