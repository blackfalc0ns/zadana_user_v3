import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_page_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/notifications_query_entity.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/get_notification_unread_count_usecase.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/mark_all_notifications_as_read_usecase.dart';
import 'package:zadana_user_v3/feature/notifications/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:zadana_user_v3/feature/notifications/presentation/manager/notifications_state.dart';

@injectable
class NotificationsViewModel extends Cubit<NotificationsState> {
  NotificationsViewModel(
    this._getNotificationsUseCase,
    this._getNotificationUnreadCountUseCase,
    this._markNotificationAsReadUseCase,
    this._markAllNotificationsAsReadUseCase,
  ) : super(const NotificationsState());

  static const double loadMoreThreshold = 320;

  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetNotificationUnreadCountUseCase _getNotificationUnreadCountUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase _markAllNotificationsAsReadUseCase;

  Future<void> loadInitial() => _loadPage(reset: true);

  Future<void> refresh() => _loadPage(reset: true);

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    await _loadPage(reset: false);
  }

  Future<void> handleScrollExtent(double extentAfter) async {
    if (extentAfter > loadMoreThreshold) return;
    await loadMore();
  }

  Future<void> refreshUnreadCount() async {
    final result = await _getNotificationUnreadCountUseCase();
    switch (result) {
      case ApiSuccessResult<int>():
        emit(state.copyWith(unreadCount: result.data));
      case ApiErrorResult<int>():
        break;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final notification = state.items
        .where((item) => item.id == notificationId)
        .firstOrNull;
    if (notification == null || notification.isRead) {
      return;
    }

    final result = await _markNotificationAsReadUseCase(notificationId);
    switch (result) {
      case ApiSuccessResult<void>():
        _setNotificationRead(notificationId);
      case ApiErrorResult<void>():
        break;
    }
  }

  Future<void> markAllAsRead() async {
    if (state.isMarkingAllRead || state.unreadCount == 0) {
      return;
    }

    emit(
      state.copyWith(
        isMarkingAllRead: true,
        feedbackMessage: null,
        clearFailure: true,
      ),
    );

    final result = await _markAllNotificationsAsReadUseCase();
    switch (result) {
      case ApiSuccessResult<void>():
        emit(
          state.copyWith(
            isMarkingAllRead: false,
            unreadCount: 0,
            items: state.items
                .map((item) => item.isRead ? item : item.copyWith(isRead: true))
                .toList(),
          ),
        );
      case ApiErrorResult<void>():
        emit(
          state.copyWith(
            isMarkingAllRead: false,
            feedbackMessage: result.failure.errorMessage,
          ),
        );
    }
  }

  void clearFeedback() {
    if (state.feedbackMessage == null) return;
    emit(state.copyWith(feedbackMessage: null));
  }

  Future<void> _loadPage({required bool reset}) async {
    final currentItems = state.items;
    final nextPage = reset ? AppConstants.firstPage : state.page + 1;

    emit(
      state.copyWith(
        isLoading: reset,
        isLoadingMore: !reset,
        initialized: true,
        clearFailure: true,
        feedbackMessage: null,
        items: reset ? const [] : currentItems,
        hasMore: reset ? true : state.hasMore,
        page: reset ? 0 : state.page,
        total: reset ? 0 : state.total,
      ),
    );

    final result = await _getNotificationsUseCase(
      NotificationsQueryEntity(
        page: nextPage,
        perPage: AppConstants.defaultPageSize,
      ),
    );

    switch (result) {
      case ApiSuccessResult<NotificationsPageEntity>():
        final mergedItems = reset
            ? result.data.items
            : [...currentItems, ...result.data.items];
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            items: mergedItems,
            hasMore: result.data.hasMore,
            page: result.data.page,
            total: result.data.total,
            unreadCount: result.data.unreadCount,
            initialized: true,
            clearFailure: true,
          ),
        );
      case ApiErrorResult<NotificationsPageEntity>():
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            items: reset ? const [] : currentItems,
            failure: result.failure,
            initialized: true,
          ),
        );
    }
  }

  void _setNotificationRead(String notificationId) {
    final updatedItems = state.items
        .map(
          (item) => item.id == notificationId ? item.copyWith(isRead: true) : item,
        )
        .toList();
    final unreadCount = updatedItems.where((item) => !item.isRead).length;
    emit(state.copyWith(items: updatedItems, unreadCount: unreadCount));
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
