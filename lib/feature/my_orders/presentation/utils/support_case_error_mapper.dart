import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/network/failures.dart';

/// Maps known backend error codes from the disputes/refund system
/// to user-friendly localized messages.
///
/// Error codes handled:
/// - `MAX_OPEN_CASES_EXCEEDED` — customer has 5+ open cases
/// - `DUPLICATE_RETURN_REQUEST` — duplicate return on same order
/// - `RETURN_WINDOW_EXPIRED` — past 14-day return window
class SupportCaseErrorMapper {
  const SupportCaseErrorMapper._();

  /// Returns a localized user-facing message for known dispute error codes.
  /// Falls back to [failure.errorMessage] if the code is not recognized.
  static String resolveMessage(BuildContext context, Failure failure) {
    final l10n = AppLocalizations.of(context)!;
    final code = failure.code.trim().toUpperCase();

    switch (code) {
      case 'MAX_OPEN_CASES_EXCEEDED':
        return l10n.error_max_open_cases_exceeded;
      case 'DUPLICATE_RETURN_REQUEST':
        return l10n.error_duplicate_return_request;
      case 'RETURN_WINDOW_EXPIRED':
        return l10n.error_return_window_expired;
      default:
        return failure.errorMessage;
    }
  }

  /// Whether the error code is a known dispute-specific error.
  static bool isKnownDisputeError(Failure failure) {
    final code = failure.code.trim().toUpperCase();
    return const {
      'MAX_OPEN_CASES_EXCEEDED',
      'DUPLICATE_RETURN_REQUEST',
      'RETURN_WINDOW_EXPIRED',
    }.contains(code);
  }
}
