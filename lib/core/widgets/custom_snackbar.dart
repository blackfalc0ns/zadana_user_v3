import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';

class CustomSnackbar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final snackBar = SnackBar(
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: getBoldStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: FontConstant.cairo,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () => scaffoldMessenger.hideCurrentSnackBar(),
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );

    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
  // Helper method to get appropriate message based on locale
  // static String getLocalizedMessage({
  //   required BuildContext context,
  //   required String messageAr,
  //   required String messageEn,
  // }) {
  //   final locale = Localizations.localeOf(context);
  //   final isArabic = locale.languageCode == 'ar';

  //   // Get the appropriate message based on locale
  //   String message = isArabic ? messageAr : messageEn;

  //   // Check if the message is a translation key (starts with 'error_')
  //   // if (message.startsWith('error_')) {
  //   //   return _translateErrorKey(context, message);
  //   // }

  //   return message;
  // }

  /// Translate error keys to localized messages
  // static String _translateErrorKey(BuildContext context, String key) {
  //   try {
  //     final l10n = AppLocalizations.of(context);
  //     if (l10n == null) return key;

  //     switch (key) {
  //       case 'error_no_internet_connection':
  //         return l10n.error_no_internet_connection;
  //       case 'error_connection_timeout':
  //         return l10n.error_connection_timeout;
  //       case 'error_receive_timeout':
  //         return l10n.error_receive_timeout;
  //       case 'error_send_timeout':
  //         return l10n.error_send_timeout;
  //       case 'error_server_error':
  //         return l10n.error_server_error;
  //       case 'error_internal_server_error':
  //         return l10n.error_internal_server_error;
  //       case 'error_bad_gateway':
  //         return l10n.error_bad_gateway;
  //       case 'error_service_unavailable':
  //         return l10n.error_service_unavailable;
  //       case 'error_gateway_timeout':
  //         return l10n.error_gateway_timeout;
  //       case 'error_bad_request':
  //         return l10n.error_bad_request;
  //       case 'error_unauthorized':
  //         return l10n.error_unauthorized;
  //       case 'error_forbidden':
  //         return l10n.error_forbidden;
  //       case 'error_not_found':
  //         return l10n.error_not_found;
  //       case 'error_method_not_allowed':
  //         return l10n.error_method_not_allowed;
  //       case 'error_not_acceptable':
  //         return l10n.error_not_acceptable;
  //       case 'error_request_timeout':
  //         return l10n.error_request_timeout;
  //       case 'error_conflict':
  //         return l10n.error_conflict;
  //       case 'error_gone':
  //         return l10n.error_gone;
  //       case 'error_length_required':
  //         return l10n.error_length_required;
  //       case 'error_precondition_failed':
  //         return l10n.error_precondition_failed;
  //       case 'error_payload_too_large':
  //         return l10n.error_payload_too_large;
  //       case 'error_uri_too_long':
  //         return l10n.error_uri_too_long;
  //       case 'error_unsupported_media_type':
  //         return l10n.error_unsupported_media_type;
  //       case 'error_range_not_satisfiable':
  //         return l10n.error_range_not_satisfiable;
  //       case 'error_expectation_failed':
  //         return l10n.error_expectation_failed;
  //       case 'error_too_many_requests':
  //         return l10n.error_too_many_requests;
  //       case 'error_unknown':
  //         return l10n.error_unknown;
  //       case 'error_cancelled':
  //         return l10n.error_cancelled;
  //       case 'error_other':
  //         return l10n.error_other;
  //       default:
  //         return key; // Return the key itself if no translation found
  //     }
  //   } catch (e) {
  //     return key; // Return the key if any error occurs
  //   }
  // }