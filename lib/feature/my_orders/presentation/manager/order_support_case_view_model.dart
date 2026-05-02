import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/data/models/order_support_case_changed_realtime_payload.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_support_case_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/repo/my_orders_repository.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_support_case_state.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';

class OrderSupportCaseViewModel extends Cubit<OrderSupportCaseState> {
  OrderSupportCaseViewModel(this._repository, this._notificationsSignalRService)
    : super(const OrderSupportCaseState());

  final MyOrdersRepository _repository;
  final NotificationsSignalRService _notificationsSignalRService;

  String? _orderId;
  StreamSubscription<OrderSupportCaseChangedRealtimePayload>?
  _realtimeSubscription;

  Future<void> initialize(String orderId, {String? initialCaseId}) async {
    _orderId = orderId;
    await _realtimeSubscription?.cancel();
    _realtimeSubscription = _notificationsSignalRService
        .watchOrderSupportCaseChangedEvents()
        .listen((payload) {
          if (payload.orderId.trim().toLowerCase() !=
              (_orderId ?? '').trim().toLowerCase()) {
            return;
          }
          unawaited(refresh());
        });
    await refresh(initialCaseId: initialCaseId);
  }

  Future<void> refresh({String? initialCaseId}) async {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty) return;

    emit(
      state.copyWith(
        isLoading: state.items.isEmpty,
        isRefreshing: state.items.isNotEmpty,
        clearFailure: true,
      ),
    );

    final listResult = await _repository.getOrderSupportCases(orderId);
    switch (listResult) {
      case ApiSuccessResult<List<OrderSupportCaseEntity>>():
        final items = listResult.data;
        final targetCaseId =
            initialCaseId ??
            state.selectedCaseId ??
            (items.isNotEmpty ? items.first.id : null);
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            items: items,
            selectedCaseId: targetCaseId,
            clearFailure: true,
          ),
        );
        if (targetCaseId != null && targetCaseId.isNotEmpty) {
          await selectCase(targetCaseId);
        } else {
          emit(state.copyWith(selectedCase: null, selectedCaseId: null));
        }
      case ApiErrorResult<List<OrderSupportCaseEntity>>():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            failure: listResult.failure,
          ),
        );
    }
  }

  Future<void> selectCase(String caseId) async {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty) return;

    emit(
      state.copyWith(
        selectedCaseId: caseId,
        isCaseLoading: true,
        clearFailure: true,
      ),
    );

    final detailsResult = await _repository.getOrderSupportCaseDetails(
      orderId,
      caseId,
    );

    switch (detailsResult) {
      case ApiSuccessResult<OrderSupportCaseEntity>():
        emit(
          state.copyWith(
            isCaseLoading: false,
            selectedCase: detailsResult.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<OrderSupportCaseEntity>():
        emit(
          state.copyWith(isCaseLoading: false, failure: detailsResult.failure),
        );
    }
  }

  @override
  Future<void> close() async {
    await _realtimeSubscription?.cancel();
    return super.close();
  }
}
