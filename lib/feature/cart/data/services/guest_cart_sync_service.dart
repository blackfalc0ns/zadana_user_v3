import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/constants.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';
import 'package:zadana_user_v3/feature/cart/domain/usecase/add_cart_item_usecase.dart';

@lazySingleton
class GuestCartSyncService {
  GuestCartSyncService(
    this._sharedPreferences,
    this._tokenService,
    this._addCartItemUseCase,
  );

  final SharedPreferences _sharedPreferences;
  final TokenService _tokenService;
  final AddCartItemUseCase _addCartItemUseCase;

  Future<void> cacheGuestCartItem(AddCartItemRequestEntity request) async {
    final token = await _tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      return;
    }

    final currentItems = await _getPendingItems();
    final updatedItems = <AddCartItemRequestEntity>[
      ...currentItems.where((item) => item.productId != request.productId),
      request,
    ];
    await _savePendingItems(updatedItems);
  }

  Future<void> syncPendingItemsIfAuthenticated() async {
    final token = await _tokenService.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    final pendingItems = await _getPendingItems();
    if (pendingItems.isEmpty) {
      return;
    }

    final failedItems = <AddCartItemRequestEntity>[];
    for (final item in pendingItems) {
      final result = await _addCartItemUseCase.call(item);
      if (result is ApiErrorResult) {
        failedItems.add(item);
      }
    }

    await _savePendingItems(failedItems);
  }

  Future<void> clearPendingItems() async {
    await _sharedPreferences.remove(AppConstants.pendingGuestCartItemsKey);
  }

  Future<void> removePendingItemByProductId(String productId) async {
    final currentItems = await _getPendingItems();
    final updatedItems = currentItems
        .where((item) => item.productId != productId)
        .toList();
    await _savePendingItems(updatedItems);
  }

  Future<void> updatePendingItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    final currentItems = await _getPendingItems();
    final updatedItems = currentItems
        .map(
          (item) => item.productId == productId
              ? AddCartItemRequestEntity(
                  productId: item.productId,
                  quantity: quantity,
                )
              : item,
        )
        .toList();
    await _savePendingItems(updatedItems);
  }

  Future<List<AddCartItemRequestEntity>> _getPendingItems() async {
    final rawItems =
        _sharedPreferences.getStringList(
          AppConstants.pendingGuestCartItemsKey,
        ) ??
        const <String>[];

    return rawItems
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .map(
          (item) => AddCartItemRequestEntity(
            productId: item['productId'] as String,
            quantity: item['quantity'] as int,
          ),
        )
        .toList();
  }

  Future<void> _savePendingItems(List<AddCartItemRequestEntity> items) async {
    final encodedItems = items
        .map(
          (item) => jsonEncode({
            'productId': item.productId,
            'quantity': item.quantity,
          }),
        )
        .toList();

    await _sharedPreferences.setStringList(
      AppConstants.pendingGuestCartItemsKey,
      encodedItems,
    );
  }
}
