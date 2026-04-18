import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/core/utils/constants.dart';
import 'package:zadana_user_v3/feature/cart/domain/entities/add_cart_item_request_entity.dart';

@lazySingleton
class GuestCartSyncService {
  GuestCartSyncService(this._sharedPreferences, this._tokenService);

  final SharedPreferences _sharedPreferences;
  final TokenService _tokenService;

  Future<void> cacheGuestCartItem(AddCartItemRequestEntity request) async {
    // Cart state should come only from the backend. Remove any legacy
    // locally-persisted cart snapshot instead of writing a new one.
    await clearPendingItems();
  }

  Future<void> syncPendingItemsIfAuthenticated() async {
    final token = await _tokenService.getToken();
    if (token == null || token.isEmpty) return;

    await clearPendingItems();
  }

  Future<void> clearPendingItems() async {
    await _sharedPreferences.remove(AppConstants.pendingGuestCartItemsKey);
  }

  Future<void> removePendingItemByProductId(String productId) async {
    await clearPendingItems();
  }

  Future<void> updatePendingItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    await clearPendingItems();
  }
}
