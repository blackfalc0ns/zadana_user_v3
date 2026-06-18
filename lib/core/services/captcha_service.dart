import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Service for managing Cloudflare Turnstile CAPTCHA tokens.
///
/// The backend requires a CAPTCHA token on:
/// - `POST /api/customers/auth/register`
/// - `POST /api/customers/auth/forgot-password`
///
/// The token is sent via the `X-Bot-Challenge-Token` header.
@lazySingleton
class CaptchaService {
  static const String captchaHeader = 'X-Bot-Challenge-Token';

  /// The Cloudflare Turnstile site key.
  /// This should be loaded from remote config or environment.
  /// Set to null/empty to disable CAPTCHA (e.g. in dev/staging).
  String? siteKey;

  /// Stores the latest CAPTCHA token obtained from the Turnstile widget.
  String? _currentToken;

  /// Sets the CAPTCHA token after the user completes the challenge.
  void setToken(String token) {
    _currentToken = token;
  }

  /// Returns and consumes the current CAPTCHA token.
  /// Returns null if no token is available.
  String? consumeToken() {
    final token = _currentToken;
    _currentToken = null;
    return token;
  }

  /// Whether CAPTCHA is enabled (site key is configured).
  bool get isEnabled => siteKey != null && siteKey!.isNotEmpty;

  /// Whether a token is currently available.
  bool get hasToken => _currentToken != null && _currentToken!.isNotEmpty;
}

/// Interceptor that attaches the CAPTCHA token to register and
/// forgot-password requests.
@injectable
class CaptchaInterceptor extends Interceptor {
  CaptchaInterceptor(this._captchaService);

  final CaptchaService _captchaService;

  static const List<String> _captchaEndpoints = [
    '/customers/auth/register',
    '/customers/auth/forgot-password',
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (_requiresCaptcha(options)) {
      final token = _captchaService.consumeToken();
      if (token != null && token.isNotEmpty) {
        options.headers[CaptchaService.captchaHeader] = token;
      }
    }
    handler.next(options);
  }

  bool _requiresCaptcha(RequestOptions options) {
    if (options.method.toUpperCase() != 'POST') return false;
    final path = options.path.toLowerCase();
    return _captchaEndpoints.any(path.contains);
  }
}
