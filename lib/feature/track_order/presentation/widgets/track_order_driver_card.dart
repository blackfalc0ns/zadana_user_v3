import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/track_order/domain/entities/order_tracking_entity.dart';

class TrackOrderDriverCard extends StatelessWidget {
  const TrackOrderDriverCard({
    super.key,
    this.driver,
    this.assignedDriver,
    this.arrivalStateLabel,
  });

  final OrderTrackingDriverEntity? driver;
  final OrderTrackingAssignedDriverEntity? assignedDriver;
  final String? arrivalStateLabel;

  Future<void> _callDriver() async {
    final phoneNumber = _phoneNumber.trim();
    if (phoneNumber.isEmpty) return;
    await launchUrlString('tel:$phoneNumber');
  }

  String get _phoneNumber =>
      assignedDriver?.phoneNumber ?? driver?.phoneNumber ?? '';

  bool get _hasPhoneNumber => _phoneNumber.trim().isNotEmpty;

  String get _title => assignedDriver?.name ?? driver?.name ?? '';

  String get _subtitle {
    final vehicleType = assignedDriver?.vehicleType.trim() ?? '';
    final compactSubtitle = driver?.subtitle.trim() ?? '';
    if (vehicleType.isNotEmpty) return vehicleType;
    return compactSubtitle;
  }

  String get _plateNumber => assignedDriver?.plateNumber.trim() ?? '';

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final title = _title.trim().isEmpty ? l10n.courier_name : _title;
    final subtitle = _subtitle;
    final arrivalStateLabel = this.arrivalStateLabel?.trim() ?? '';
    final phoneNumber = _phoneNumber;
    final plateNumber = _plateNumber;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withValues(alpha: .2)),
      ),
      child: Row(
        children: [
          if (_hasPhoneNumber) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF7EBDD),
                borderRadius: BorderRadius.circular(999),
              ),
              child: IconButton(
                onPressed: _callDriver,
                icon: const Icon(Icons.call_outlined, color: Color(0xFFE58E1A)),
                tooltip: l10n.phone,
              ),
            ),
            const SizedBox(width: Spacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: getMediumStyle(
                    fontSize: 20,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.end,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
                if (plateNumber.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    plateNumber,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
                if (phoneNumber.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    phoneNumber,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.primary,
                    ),
                  ),
                ],
                if (arrivalStateLabel.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    arrivalStateLabel,
                    textAlign: TextAlign.end,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.secondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Spacing.md),
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFDFF2F8),
            child: Icon(Icons.person_rounded, color: color.primary, size: 28),
          ),
        ],
      ),
    );
  }
}
