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
    final plateNumber = _plateNumber;

    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withValues(alpha: .16)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: .04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_hasPhoneNumber) ...[
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF7EBDD),
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1FE58E1A),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _callDriver,
                icon: const Icon(Icons.call_rounded, color: Color(0xFFE58E1A)),
                tooltip: l10n.phone,
              ),
            ),
            const SizedBox(width: Spacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: getMediumStyle(
                    fontSize: 18,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.end,
                  children: [
                    if (subtitle.isNotEmpty)
                      _DriverMetaChip(
                        label: subtitle,
                        icon: Icons.two_wheeler_rounded,
                        background: color.primary.withValues(alpha: .08),
                        foreground: color.primary,
                      ),
                    if (plateNumber.isNotEmpty)
                      _DriverMetaChip(
                        label: plateNumber,
                        icon: Icons.badge_outlined,
                        background: color.surfaceContainerHighest.withValues(
                          alpha: .5,
                        ),
                        foreground: color.onSurfaceVariant,
                      ),
                  ],
                ),
                if (arrivalStateLabel.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 10,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: color.secondary.withValues(alpha: .12),
                  //     borderRadius: BorderRadius.circular(999),
                  //   ),
                  //   child: Text(
                  //     arrivalStateLabel,
                  //     textAlign: TextAlign.end,
                  //     style: getMediumStyle(
                  //       fontFamily: FontConstant.cairo,
                  //       color: color.secondary,
                  //     ),
                  //   ),
                  // ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: color.primary, size: 22),
          ),
        ],
      ),
    );
  }
}

class _DriverMetaChip extends StatelessWidget {
  const _DriverMetaChip({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
