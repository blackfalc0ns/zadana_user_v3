import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/errors/api_error_type.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

import 'base_error_widget.dart';

class ServerErrorWidget extends BaseErrorWidget {
  const ServerErrorWidget({
    super.key,
    required this.serverErrorType,
    this.statusCode,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onContactSupport,
  }) : super(
         title: '',
         description: '',
         icon: Icons.error_outline,
         onSecondaryAction: onContactSupport,
         secondaryActionText: '',
         visualType: ErrorVisualType.server,
         retryIcon: Icons.restart_alt_rounded,
         secondaryActionIcon: Icons.support_agent_rounded,
       );

  final ApiErrorType serverErrorType;
  final int? statusCode;
  final String? serverMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String title;
    String description;
    IconData iconData = Icons.error_outline;

    switch (serverErrorType) {
      case ApiErrorType.internalServerError:
        title = l10n?.error_internal_server_error ?? '';
        description = l10n?.error_internal_server_error_desc ?? '';
        iconData = Icons.dns_rounded;
        break;
      case ApiErrorType.badGateway:
        title = l10n?.error_bad_gateway ?? '';
        description = l10n?.error_bad_gateway_desc ?? '';
        iconData = Icons.router_rounded;
        break;
      case ApiErrorType.serviceUnavailable:
        title = l10n?.error_service_unavailable ?? '';
        description = l10n?.error_service_unavailable_desc ?? '';
        iconData = Icons.cloud_off_rounded;
        break;
      case ApiErrorType.gatewayTimeout:
        title = l10n?.error_gateway_timeout ?? '';
        description = l10n?.error_gateway_timeout_desc ?? '';
        iconData = Icons.timer_off_rounded;
        break;
      default:
        title = l10n?.error_server_error ?? '';
        description = l10n?.error_server_error_desc ?? '';
        iconData = Icons.storage_rounded;
    }

    final finalDescription = serverMessage ?? description;

    return BaseErrorWidget(
      title: title,
      description: finalDescription,
      icon: iconData,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: l10n?.contact_support ?? '',
      visualType: ErrorVisualType.server,
      retryIcon: Icons.restart_alt_rounded,
      secondaryActionIcon: Icons.support_agent_rounded,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
