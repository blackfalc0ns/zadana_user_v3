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
          unawaited(refresh(initialCaseId: payload.caseId));
        });
    await refresh(initialCaseId: initialCaseId);
  }

  void clearFeedback() {
    if (state.feedbackMessage == null) return;
    emit(state.copyWith(feedbackMessage: null));
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
        final requestedCaseId = initialCaseId ?? state.selectedCaseId;
        final targetCaseId = _resolveTargetCaseId(
          items: items,
          requestedCaseId: requestedCaseId,
        );
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

  Future<void> sendMessage(
    String caseId, {
    required String message,
    required List<String> attachmentPaths,
  }) async {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty || state.isSendingMessage) return;

    emit(
      state.copyWith(
        isSendingMessage: true,
        clearFailure: true,
        feedbackMessage: null,
        isFeedbackError: false,
      ),
    );

    final uploadedAttachments = <OrderSupportCaseAttachmentEntity>[];
    for (final path in attachmentPaths) {
      if (path.trim().isEmpty) {
        continue;
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
              isSendingMessage: false,
              feedbackMessage: uploadResult.failure.errorMessage,
              isFeedbackError: true,
            ),
          );
          return;
      }
    }

    final sendResult = await _repository.sendOrderSupportCaseMessage(
      orderId,
      caseId,
      message,
      uploadedAttachments,
    );

    switch (sendResult) {
      case ApiSuccessResult<void>():
        await selectCase(caseId);
        emit(
          state.copyWith(
            isSendingMessage: false,
            feedbackMessage: 'Message sent',
            isFeedbackError: false,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<void>():
        emit(
          state.copyWith(
            isSendingMessage: false,
            feedbackMessage: sendResult.failure.errorMessage,
            isFeedbackError: true,
          ),
        );
    }
  }

  Future<void> selectCase(String caseId) async {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty) return;

    final targetCaseId = _resolveTargetCaseId(
      items: state.items,
      requestedCaseId: caseId,
    );
    if (targetCaseId == null || targetCaseId.isEmpty) {
      emit(
        state.copyWith(
          selectedCaseId: null,
          selectedCase: null,
          isCaseLoading: false,
          clearFailure: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedCaseId: targetCaseId,
        isCaseLoading: true,
        clearFailure: true,
      ),
    );

    final detailsResult = await _repository.getOrderSupportCaseDetails(
      orderId,
      targetCaseId,
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
        final fallbackCaseId = _resolveFallbackCaseId(
          items: state.items,
          failedCaseId: targetCaseId,
        );
        if (fallbackCaseId != null && fallbackCaseId != targetCaseId) {
          emit(
            state.copyWith(
              isCaseLoading: false,
              selectedCaseId: fallbackCaseId,
              clearFailure: true,
            ),
          );
          await selectCase(fallbackCaseId);
          return;
        }

        emit(
          state.copyWith(isCaseLoading: false, failure: detailsResult.failure),
        );
    }
  }

  String? _resolveTargetCaseId({
    required List<OrderSupportCaseEntity> items,
    required String? requestedCaseId,
  }) {
    final normalizedRequestedCaseId = requestedCaseId?.trim();
    if (normalizedRequestedCaseId != null &&
        normalizedRequestedCaseId.isNotEmpty) {
      final matchingItem = items.where(
        (item) => item.id == normalizedRequestedCaseId,
      );
      if (matchingItem.isNotEmpty) {
        return normalizedRequestedCaseId;
      }
    }

    if (items.isEmpty) {
      return null;
    }

    return items.first.id;
  }

  String? _resolveFallbackCaseId({
    required List<OrderSupportCaseEntity> items,
    required String failedCaseId,
  }) {
    for (final item in items) {
      if (item.id != failedCaseId) {
        return item.id;
      }
    }
    return null;
  }

  @override
  Future<void> close() async {
    await _realtimeSubscription?.cancel();
    return super.close();
  }
}
