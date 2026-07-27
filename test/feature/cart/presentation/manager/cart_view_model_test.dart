import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/cart_summary_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/get_cart_response_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/repo/cart_repository.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/clear_cart_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/get_cart_vendors_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/remove_cart_item_usecase.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/update_cart_item_quantity_usecase.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_event.dart';
import 'package:zadana_user_v3/feature/cart/presentation/manager/cart_view_model.dart';

void main() {
  test(
    'does not emit when an items request completes after the cubit is closed',
    () async {
      final repository = _DelayedCartRepository();
      final viewModel = CartViewModel(
        GetCartVendorsUseCase(repository),
        GetCartUseCase(repository),
        ClearCartUseCase(repository),
        RemoveCartItemUseCase(repository),
        UpdateCartItemQuantityUseCase(repository),
      );

      viewModel.doIntent(const CartLoadItemsEvent());
      expect(viewModel.state.isLoadingItems, isTrue);

      await viewModel.close();
      repository.getCartCompleter.complete(
        ApiSuccessResult(
          data: const GetCartResponseEntity(
            items: [],
            summary: CartSummaryEntity(itemsCount: 0, totalQuantity: 0),
            total: 0,
            limit: 20,
            offset: 0,
            hasMore: false,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.isClosed, isTrue);
      expect(
        () => viewModel.doIntent(const CartLoadItemsEvent()),
        returnsNormally,
      );
    },
  );
}

class _DelayedCartRepository implements CartRepository {
  final Completer<ApiResult<GetCartResponseEntity>> getCartCompleter =
      Completer<ApiResult<GetCartResponseEntity>>();

  @override
  Future<ApiResult<GetCartResponseEntity>> getCart({
    String? vendorId,
    int limit = 20,
    int offset = 0,
  }) {
    return getCartCompleter.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
