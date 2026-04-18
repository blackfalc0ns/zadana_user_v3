import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';

class NotificationsState {
  const NotificationsState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMarkingAllRead = false,
    this.hasMore = true,
    this.page = 0,
    this.total = 0,
    this.unreadCount = 0,
    this.failure,
    this.feedbackMessage,
    this.initialized = false,
  });

  static const _unset = Object();

  final List<AppNotificationEntity> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMarkingAllRead;
  final bool hasMore;
  final int page;
  final int total;
  final int unreadCount;
  final Failure? failure;
  final String? feedbackMessage;
  final bool initialized;

  NotificationsState copyWith({
    List<AppNotificationEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMarkingAllRead,
    bool? hasMore,
    int? page,
    int? total,
    int? unreadCount,
    Failure? failure,
    Object? feedbackMessage = _unset,
    bool? initialized,
    bool clearFailure = false,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      total: total ?? this.total,
      unreadCount: unreadCount ?? this.unreadCount,
      failure: clearFailure ? null : failure ?? this.failure,
      feedbackMessage: identical(feedbackMessage, _unset)
          ? this.feedbackMessage
          : feedbackMessage as String?,
      initialized: initialized ?? this.initialized,
    );
  }
}
