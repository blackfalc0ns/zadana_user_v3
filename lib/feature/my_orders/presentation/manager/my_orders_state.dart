import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_list_item_entity.dart';

enum OrdersTabType { active, completed, returned }

class OrdersTabState {
  const OrdersTabState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 0,
    this.total = 0,
    this.failure,
    this.initialized = false,
  });

  final List<OrderListItemEntity> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final int total;
  final Failure? failure;
  final bool initialized;

  OrdersTabState copyWith({
    List<OrderListItemEntity>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    int? total,
    Failure? failure,
    bool? initialized,
    bool clearFailure = false,
  }) {
    return OrdersTabState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      total: total ?? this.total,
      failure: clearFailure ? null : failure ?? this.failure,
      initialized: initialized ?? this.initialized,
    );
  }
}

class MyOrdersState {
  const MyOrdersState({
    this.active = const OrdersTabState(),
    this.completed = const OrdersTabState(),
    this.returned = const OrdersTabState(),
  });

  final OrdersTabState active;
  final OrdersTabState completed;
  final OrdersTabState returned;

  MyOrdersState copyWith({
    OrdersTabState? active,
    OrdersTabState? completed,
    OrdersTabState? returned,
  }) {
    return MyOrdersState(
      active: active ?? this.active,
      completed: completed ?? this.completed,
      returned: returned ?? this.returned,
    );
  }

  OrdersTabState sectionOf(OrdersTabType type) {
    switch (type) {
      case OrdersTabType.active:
        return active;
      case OrdersTabType.completed:
        return completed;
      case OrdersTabType.returned:
        return returned;
    }
  }

  MyOrdersState withSection(OrdersTabType type, OrdersTabState section) {
    switch (type) {
      case OrdersTabType.active:
        return copyWith(active: section);
      case OrdersTabType.completed:
        return copyWith(completed: section);
      case OrdersTabType.returned:
        return copyWith(returned: section);
    }
  }
}
