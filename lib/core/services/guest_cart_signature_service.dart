import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/core/services/device_id_service.dart';

/// Manages the HMAC signature required for guest cart mutations.
///
/// The backend requires `X-Device-Signature` on all cart write operations
/// for unauthenticated (guest) users. The signature is obtained once per
/// device via `POST /api/cart/guest-token` and cached in secure storage.
@lazySingleton
class GuestCartSignatureService {
  GuestCartSignatureService(this._deviceIdService);

  final DeviceIdService _deviceIdService;

  static const String _signatureStorageKey = 'guest_cart_signature';
  static const String _guestTokenEndpoint = '/cart/guest-token';
  static const String signatureHeader = 'X-Device-Signature';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Returns the cached signature or fetches a new one from the backend.
  Future<String?> getOrFetchSignature() async {
    final cached = await _secureStorage.read(key: _signatureStorageKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    return _fetchAndCacheSignature();
  }

  /// Forces a fresh signature fetch from the backend.
  Future<String?> refreshSignature() async {
    await _secureStorage.delete(key: _signatureStorageKey);
    return _fetchAndCacheSignature();
  }

  /// Clears the stored signature (e.g. on logout or device id change).
  Future<void> clearSignature() async {
    await _secureStorage.delete(key: _signatureStorageKey);
  }

  Future<String?> _fetchAndCacheSignature() async {
    try {
      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      // Use a standalone Dio instance to avoid circular dependency with
      // the main Dio that has interceptors depending on this service.
      final dio = Dio(BaseOptions(
        baseUrl: NetworkConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      final response = await dio.post<Map<String, dynamic>>(
        _guestTokenEndpoint,
        data: {'deviceId': deviceId},
      );

      final signature = response.data?['signature']?.toString();
      if (signature != null && signature.isNotEmpty) {
        await _secureStorage.write(
          key: _signatureStorageKey,
          value: signature,
        );
        return signature;
      }
    } catch (e) {
      // Log the error in debug mode for easier diagnosis on real devices.
      assert(() {
        // ignore: avoid_print
        print('[GuestCartSignatureService] Failed to fetch signature: $e');
        return true;
      }());
    }
    return null;
  }
}
