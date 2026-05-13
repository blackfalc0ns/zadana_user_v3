import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';

class NotificationsGuestView extends StatelessWidget {
  const NotificationsGuestView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.localization;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.notifications),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.xl,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 126,
                        height: 126,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_off_outlined,
                          size: 56,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        l10n.notifications,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          color: colors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        l10n.profile_guest_title,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size20,
                          color: colors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        l10n.profile_notifications_subtitle,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size15,
                          color: colors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        l10n.profile_guest_subtitle,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.login),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.primary,
                            side: BorderSide(
                              color: colors.primary.withValues(alpha: 0.85),
                              width: 1.4,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            l10n.btn_login,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
