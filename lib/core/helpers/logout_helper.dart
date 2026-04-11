import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/services/token_service.dart';
import 'package:zadana_user_v3/feature/auth/logout/domain/entities/logout_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/logout/domain/usecase/logout_usecase.dart';

class LogoutHelper {
  static Future<void> performLogout(BuildContext context) async {
    final tokenService = getIt<TokenService>();
    final refreshToken = await tokenService.getRefreshToken() ?? '';

    if (refreshToken.isNotEmpty) {
      await getIt<LogoutUseCase>().call(
        LogoutRequestEntity(refreshToken: refreshToken),
      );
    }

    await tokenService.clearTokens();

    if (!context.mounted) return;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }
}
