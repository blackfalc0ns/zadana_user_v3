import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zadana_user_v3/config/routing/app_routes.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_driver_card.dart';
import 'package:zadana_user_v3/feature/track_order/presentation/widgets/track_order_time_line.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    const steps = [
      ('تم استلام الطلب', true),
      ('جاري التحضير', true),
      ('خرج للتوصيل', false),
      ('تم التسليم', false),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: AppBar(
          title: Text(
            'تتبع الطلب',
            style: getRegularStyle(
              fontSize: 22,
              fontFamily: FontConstant.cairo,
              color: color.onSurface,
            ),
          ),
        ),
        body: Column(
          children: [
            // ── Scrollable content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── ETA Card ──
                    Container(
                      padding: const EdgeInsets.all(Spacing.base),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.primary.withValues(alpha: 0.1),
                            color.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: color.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'موعد الوصول المتوقع',
                                style: getBoldStyle(
                                  fontSize: FontSize.size15,
                                  fontFamily: FontConstant.cairo,
                                  color: color.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '03 سبتمبر 2026، 11:00 ص',
                            style: getBoldStyle(
                              fontSize: FontSize.size18,
                              fontFamily: FontConstant.cairo,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.base),

                    // ── Driver Card ──
                    const TrackOrderDriverCard(),

                    const SizedBox(height: Spacing.base),

                    // ── Delivery Illustration ──
                    Container(
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.outline.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/fast_delivery.svg',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: Spacing.base),

                    // ── Order Steps ──
                    Container(
                      padding: const EdgeInsets.all(Spacing.base),
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.outline.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.track_changes_rounded,
                                color: color.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'خطوات الطلب',
                                style: getBoldStyle(
                                  fontSize: FontSize.size16,
                                  fontFamily: FontConstant.cairo,
                                  color: color.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.base),
                          ...steps.asMap().entries.map(
                                (entry) => TrackOrderTimelineTile(
                                  title: entry.value.$1,
                                  time: '03 سبتمبر 2026 - 2:10',
                                  active: entry.value.$2,
                                  last: entry.key == steps.length - 1,
                                  showButton: entry.key == 2,
                                ),
                              ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.base),
                  ],
                ),
              ),
            ),

            // ── Bottom Button ──
            Container(
              padding: const EdgeInsets.fromLTRB(
                Spacing.base,
                Spacing.base,
                Spacing.base,
                Spacing.lg,
              ),
              decoration: BoxDecoration(
                color: color.surface,
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: AppButton(
                text: 'عرض الطلبات',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.orders),
                color: color.primary,
                textColor: color.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


