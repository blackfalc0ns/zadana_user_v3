import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class DeliveryDateTimeSelector extends StatefulWidget {
  final DateTime? initialDateTime;
  final ValueChanged<DateTime>? onDateTimeChanged;

  const DeliveryDateTimeSelector({
    super.key,
    this.initialDateTime,
    this.onDateTimeChanged,
  });

  @override
  State<DeliveryDateTimeSelector> createState() => _DeliveryDateTimeSelectorState();
}

class _DeliveryDateTimeSelectorState extends State<DeliveryDateTimeSelector> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime ?? _getDefaultDateTime();
  }

  DateTime _getDefaultDateTime() {
    final now = DateTime.now();
    // Bir sonraki saati hesapla (örn: 14:32 -> 15:00)
    final nextHour = now.hour + 1;
    return DateTime(now.year, now.month, now.day, nextHour, 0);
  }

  Future<void> _showDateTimePicker() async {
    HapticFeedback.lightImpact();

    final colors = Theme.of(context).colorScheme;

    // Önce tarih seç
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colors.brightness == Brightness.dark
                ? const ColorScheme.dark(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    surface: Color(0xFF121212),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ), dialogTheme: DialogThemeData(backgroundColor: colors.surface),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // Sonra saat seç
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colors.brightness == Brightness.dark
                ? const ColorScheme.dark(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    surface: Color(0xFF121212),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ), dialogTheme: DialogThemeData(backgroundColor: colors.surface),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });

    widget.onDateTimeChanged?.call(_selectedDateTime!);
  }

  String _formatDateTime(BuildContext context) {
    if (_selectedDateTime == null) {
      return 'حدد التاريخ والوقت';
    }

    final date = _selectedDateTime!;
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    String dateText;
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      dateText = 'اليوم';
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      dateText = 'غداً';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$dateText - $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasSelection = _selectedDateTime != null;

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.calendar_today_outlined,
            title: 'تاريخ ووقت التسليم',
            trailing: hasSelection
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() => _selectedDateTime = null);
                        widget.onDateTimeChanged?.call(DateTime.now());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: colors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'إعادة تعيين',
                          style: getBoldStyle(
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                            color: colors.error,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: Spacing.md),

          // DateTime Selector Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showDateTimePicker,
              borderRadius: BorderRadius.circular(Spacing.sm + 2),
              child: Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: hasSelection
                      ? colors.primary.withValues(alpha: 0.06)
                      : colors.surface,
                  borderRadius: BorderRadius.circular(Spacing.sm + 2),
                  border: Border.all(
                    color: hasSelection
                        ? colors.primary.withValues(alpha: 0.3)
                        : colors.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: hasSelection
                            ? colors.primary.withValues(alpha: 0.12)
                            : colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(Spacing.sm),
                      ),
                      child: Icon(
                        hasSelection ? Icons.event_available : Icons.event_outlined,
                        color: hasSelection ? colors.primary : colors.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasSelection ? 'تم تحديد وقت التسليم' : 'اختر وقت التسليم',
                            style: getMediumStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDateTime(context),
                            style: getBoldStyle(
                              fontSize: FontSize.size14,
                              fontFamily: FontConstant.cairo,
                              color: hasSelection ? colors.primary : colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colors.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (hasSelection) ...[
            const SizedBox(height: Spacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(Spacing.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: colors.secondary,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    'قد يختلف وقت التسليم حسب التوفر',
                    style: getRegularStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
