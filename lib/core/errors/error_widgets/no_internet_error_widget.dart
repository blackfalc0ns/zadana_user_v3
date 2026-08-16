import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'base_error_widget.dart';

class NoInternetErrorWidget extends BaseErrorWidget {
  const NoInternetErrorWidget({
    super.key,
    super.onRetry,
    VoidCallback? onCheckConnection,
  }) : super(
         title: '',
         description: '',
         icon: Icons.wifi_off,
         onSecondaryAction: onCheckConnection,
         secondaryActionText: '',
         visualType: ErrorVisualType.network,
         retryIcon: Icons.wifi_find_rounded,
         secondaryActionIcon: Icons.settings_input_antenna_rounded,
       );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BaseErrorWidget(
      title: l10n?.error_no_internet_connection ?? '',
      description: l10n?.error_no_internet_connection_desc ?? '',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: l10n?.check_connection ?? '',
      visualType: ErrorVisualType.network,
      retryIcon: Icons.wifi_find_rounded,
      secondaryActionIcon: Icons.settings_input_antenna_rounded,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
