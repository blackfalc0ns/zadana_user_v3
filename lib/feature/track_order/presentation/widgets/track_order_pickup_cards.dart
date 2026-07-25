import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';

class TrackOrderPickupBranchCard extends StatelessWidget {
  const TrackOrderPickupBranchCard({super.key, required this.branch});

  final OrderPickupBranchEntity branch;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final address = branch.displayAddress;
    final hours = branch.hoursToday?.trim() ?? '';

    return _PickupCardShell(
      icon: Icons.storefront_outlined,
      title: l10n.pickup_branch_title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            branch.name,
            style: getBoldStyle(
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
          if (address.isNotEmpty) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              address,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
          if (hours.isNotEmpty) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              hours,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                color: color.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class TrackOrderPickupOtpCard extends StatelessWidget {
  const TrackOrderPickupOtpCard({
    super.key,
    required this.tracking,
    required this.isResending,
    required this.onResend,
  });

  final OrderTrackingEntity tracking;
  final bool isResending;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final expiresAt = tracking.pickupOtpExpiresAtUtc;
    final deadline = tracking.pickupNoShowDeadlineUtc;

    return _PickupCardShell(
      icon: Icons.pin_outlined,
      title: l10n.pickup_code_title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            tracking.pickupOtpCode,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontSize: 40,
              fontFamily: FontConstant.cairo,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            l10n.pickup_code_instruction,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurfaceVariant,
            ),
          ),
          if (expiresAt != null || deadline != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              _buildTimeText(
                l10n: l10n,
                locale: locale,
                expiresAt: expiresAt,
                deadline: deadline,
              ),
              textAlign: TextAlign.center,
              style: getMediumStyle(
                fontSize: FontSize.size13,
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Spacing.base),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: isResending ? null : onResend,
              style: OutlinedButton.styleFrom(
                foregroundColor: color.primary,
                side: BorderSide(color: color.primary),
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                ),
              ),
              icon: isResending
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color.primary,
                      ),
                    )
                  : const Icon(Icons.refresh_rounded, size: 20),
              label: Text(
                l10n.pickup_code_resend,
                style: getBoldStyle(
                  fontSize: FontSize.size13,
                  fontFamily: FontConstant.cairo,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildTimeText({
    required AppLocalizations l10n,
    required String locale,
    required DateTime? expiresAt,
    required DateTime? deadline,
  }) {
    final formatter = intl.DateFormat('dd MMM yyyy, hh:mm a', locale);
    if (expiresAt != null) {
      return l10n.pickup_code_expires(formatter.format(expiresAt.toLocal()));
    }
    if (deadline != null) {
      return l10n.pickup_deadline(formatter.format(deadline.toLocal()));
    }
    return '';
  }
}

class _PickupCardShell extends StatelessWidget {
  const _PickupCardShell({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: color.primary),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: getBoldStyle(
                    fontSize: FontSize.size18,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.base),
          child,
        ],
      ),
    );
  }
}
