import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/font_manger.dart';
import 'package:zadana_user_v3/config/theme/styles_manger.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

class CourierInfoCard extends StatelessWidget {
  const CourierInfoCard({
    super.key,
    required this.courierName,
    this.courierImage,
  });

  final String courierName;
  final String? courierImage;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(
              alpha: 0.05,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColors.primary,
                width: 0.5,
              ),
              image: DecorationImage(
                image: NetworkImage(
                  courierImage ??
                      'https://static.vecteezy.com/system/resources/previews/026/632/760/large_2x/user-icon-symbol-design-illustration-vector.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.courier_name,
                  style: getRegularStyle(
                    fontSize: FontSize.size11,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  courierName,
                  style: getBoldStyle(
                    fontSize: FontSize.size15,
                    fontFamily: FontConstant.cairo,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
