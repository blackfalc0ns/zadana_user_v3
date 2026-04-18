import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_status.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_order_details_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/order_details_state.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_shared.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_sheets.dart';

@injectable
class OrderDetailsViewModel extends Cubit<OrderDetailsState> {
  OrderDetailsViewModel(this._getOrderDetailsUseCase)
    : super(const OrderDetailsState());

  final GetOrderDetailsUseCase _getOrderDetailsUseCase;

  Future<void> load(String orderId) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearFailure: true,
        feedbackMessage: null,
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

  void applyCancel(OrderCancelResult result) {
    emit(
      state.copyWith(
        status: OrderStatus.cancelled,
        message: result.note,
        cancelReason: result.reason,
        feedbackMessage: result.feedbackMessage,
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

  OrderStatus resolveStatus(OrderStatus fallbackStatus) {
    return state.status ?? state.order?.status ?? fallbackStatus;
  }

  String currentMessage() => state.message;

  List<PlatformFile> currentAttachments() => state.attachments;

  Future<void> handleCancelPressed(
    BuildContext context, {
    required OrderStatus fallbackStatus,
    required double fallbackTotalPrice,
  }) async {
    final result = await showOrderCancelSheet(
      context: context,
      status: resolveStatus(fallbackStatus),
      total: _money(context, state.order?.totalPrice ?? fallbackTotalPrice),
      initialNote: currentMessage(),
    );

    if (result == null || !context.mounted) return;
    applyCancel(result);
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

  String _money(BuildContext context, double value) {
    final l10n = AppLocalizations.of(context)!;
    return '${value.toStringAsFixed(2)} ${l10n.currency}';
  }
}
