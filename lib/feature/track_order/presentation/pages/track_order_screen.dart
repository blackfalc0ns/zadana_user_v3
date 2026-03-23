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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.base,
            Spacing.base,
            Spacing.base,
            Spacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'موعد الوصول المتوقع',
                style: getMediumStyle(
                  fontSize: FontSize.size15,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '03 سبتمبر 2026، 11:00 ص',
                style: getMediumStyle(
                  fontSize: FontSize.size17,
                  fontFamily: FontConstant.cairo,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.base),
              Divider(color: color.outlineVariant),
              const SizedBox(height: Spacing.base),
              const TrackOrderDriverCard(),
              Center(
                child: SvgPicture.asset(
                  'assets/images/fast_delivery.svg',
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: steps.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 2),
                  itemBuilder: (context, index) => TrackOrderTimelineTile(
                    title: steps[index].$1,
                    time: '03 سبتمبر 2026 - 2:10',
                    active: steps[index].$2,
                    last: index == steps.length - 1,
                  ),
                ),
              ),
              AppButton(
                text: 'عرض الطلبات',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.orders),
                color: color.primary,
                textColor: color.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


