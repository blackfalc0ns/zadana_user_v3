import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/notifications/domain/entities/app_notification_entity.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotificationEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.toLowerCase().startsWith('ar');
    final title = isArabic ? notification.titleAr : notification.titleEn;
    final body = isArabic ? notification.bodyAr : notification.bodyEn;
    final dateLabel = DateFormat.yMMMd(locale).add_jm().format(
      notification.createdAtUtc.toLocal(),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: notification.isRead
              ? colors.surface
              : colors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notification.isRead
                ? colors.outlineVariant
                : colors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: notification.isRead
                    ? colors.surfaceContainerHighest
                    : colors.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _resolveIcon(notification.type),
                color: notification.isRead
                    ? colors.onSurfaceVariant
                    : colors.primary,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title.trim().isEmpty
                              ? context.localization.notifications
                              : title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size15,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      if (!notification.isRead) ...[
                        const SizedBox(width: Spacing.sm),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body.trim().isEmpty ? notification.type ?? '' : body,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dateLabel,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _resolveIcon(String? type) {
    switch (type) {
      case 'order_status_changed':
      case 'order_placed':
        return Icons.local_shipping_outlined;
      case 'order_cancelled':
        return Icons.cancel_outlined;
      case 'new_banner':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}
