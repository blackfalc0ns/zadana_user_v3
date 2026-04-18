import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';

class CartCacheInvalidator {
  const CartCacheInvalidator(this._cacheStore);

  final CacheStore _cacheStore;

  static const String _checkoutSummaryEndpoint = '/checkout/summary';

  Future<void> clearCartCache() {
    return _cacheStore.deleteFromPath(_buildEndpointPattern(EndPoints.cart));
  }

  Future<void> clearCheckoutSummaryCache() {
    return _cacheStore.deleteFromPath(
      _buildEndpointPattern(_checkoutSummaryEndpoint),
    );
  }

  RegExp _buildEndpointPattern(String endpoint) {
    return RegExp(
      '^${RegExp.escape('${NetworkConstants.baseUrl}$endpoint')}(?:[/?].*)?\$',
    );
  }
}
