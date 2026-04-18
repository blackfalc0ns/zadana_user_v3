import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/constants/app_constants.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/paginated_orders_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_active_orders_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_completed_orders_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/usecase/get_returned_orders_usecase.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/manager/my_orders_state.dart';

@injectable
class MyOrdersViewModel extends Cubit<MyOrdersState> {
  MyOrdersViewModel(
    this._getActiveOrdersUseCase,
    this._getCompletedOrdersUseCase,
    this._getReturnedOrdersUseCase,
  ) : super(const MyOrdersState());

  static const double loadMoreThreshold = 320;

  final GetActiveOrdersUseCase _getActiveOrdersUseCase;
  final GetCompletedOrdersUseCase _getCompletedOrdersUseCase;
  final GetReturnedOrdersUseCase _getReturnedOrdersUseCase;

  Future<void> loadInitial() async {
    await Future.wait([
      _loadSection(OrdersTabType.active, reset: true),
      _loadSection(OrdersTabType.completed, reset: true),
      _loadSection(OrdersTabType.returned, reset: true),
    ]);
  }

  Future<void> refreshTab(OrdersTabType type) {
    return _loadSection(type, reset: true);
  }

  Future<void> loadMore(OrdersTabType type) async {
    final section = state.sectionOf(type);
    if (section.isLoading || section.isLoadingMore || !section.hasMore) {
      return;
    }

    await _loadSection(type, reset: false);
  }

  Future<void> handleScrollExtent(
    OrdersTabType type,
    double extentAfter,
  ) async {
    if (extentAfter > loadMoreThreshold) {
      return;
    }

    await loadMore(type);
  }

  Future<void> _loadSection(OrdersTabType type, {required bool reset}) async {
    final current = state.sectionOf(type);
    final nextPage = reset ? AppConstants.firstPage : current.page + 1;

    emit(
      state.withSection(
        type,
        current.copyWith(
          isLoading: reset,
          isLoadingMore: !reset,
          initialized: true,
          clearFailure: true,
          items: reset ? const [] : null,
          hasMore: reset ? true : null,
          page: reset ? 0 : null,
          total: reset ? 0 : null,
        ),
      ),
    );

    final result = await _execute(
      type,
      page: nextPage,
      perPage: AppConstants.defaultPageSize,
    );

    switch (result) {
      case ApiSuccessResult<PaginatedOrdersEntity>():
        final mergedItems = reset
            ? result.data.items
            : [...current.items, ...result.data.items];
        emit(
          state.withSection(
            type,
            state
                .sectionOf(type)
                .copyWith(
                  items: mergedItems,
                  isLoading: false,
                  isLoadingMore: false,
                  hasMore: result.data.hasMore,
                  page: result.data.page,
                  total: result.data.total,
                  initialized: true,
                  clearFailure: true,
                ),
          ),
        );
      case ApiErrorResult<PaginatedOrdersEntity>():
        emit(
          state.withSection(
            type,
            state
                .sectionOf(type)
                .copyWith(
                  isLoading: false,
                  isLoadingMore: false,
                  failure: result.failure,
                  initialized: true,
                ),
          ),
        );
    }
  }

  Future<ApiResult<PaginatedOrdersEntity>> _execute(
    OrdersTabType type, {
    required int page,
    required int perPage,
  }) {
    switch (type) {
      case OrdersTabType.active:
        return _getActiveOrdersUseCase(page: page, perPage: perPage);
      case OrdersTabType.completed:
        return _getCompletedOrdersUseCase(page: page, perPage: perPage);
      case OrdersTabType.returned:
        return _getReturnedOrdersUseCase(page: page, perPage: perPage);
    }
  }
}
