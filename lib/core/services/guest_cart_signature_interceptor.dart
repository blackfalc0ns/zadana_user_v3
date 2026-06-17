import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/services/guest_cart_signature_service.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';

/// Interceptor that attaches `X-Device-Signature` to guest cart mutations.
///
/// Only applies to unauthenticated users performing write operations on
/// cart endpoints (POST, PATCH, DELETE on `/cart/items` or `/cart`).
@injectable
class GuestCartSignatureInterceptor extends Interceptor {
  GuestCartSignatureInterceptor(
    this._tokenService,
    this._guestCartSignatureService,
  );

  final TokenService _tokenService;
  final GuestCartSignatureService _guestCartSignatureService;

  static const List<String> _cartMutationPaths = [
    '/cart/items',
    '/cart',
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isGuestCartMutation(options)) {
      handler.next(options);
      return;
    }

    final token = await _tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      // Authenticated user — no signature needed.
      handler.next(options);
      return;
    }

    // Guest user — must attach device signature.
    // Try fetching the signature, with one retry if the first attempt fails.
    String? signature = await _guestCartSignatureService.getOrFetchSignature();
    if (signature == null || signature.isEmpty) {
      // Retry once — could be a transient network issue.
      signature = await _guestCartSignatureService.refreshSignature();
    }

    if (signature != null && signature.isNotEmpty) {
      options.headers[GuestCartSignatureService.signatureHeader] = signature;
      handler.next(options);
    } else {
      // Cannot proceed without a valid signature — reject the request
      // locally to avoid sending a request that will definitely fail.
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error:
              'Unable to obtain guest cart signature. '
              'Please check your internet connection and try again.',
        ),
        true,
      );
    }
  }

  bool _isGuestCartMutation(RequestOptions options) {
    final method = options.method.toUpperCase();
    if (method == 'GET') return false;

    final path = options.path.toLowerCase();
    return _cartMutationPaths.any(path.contains);
  }
}
