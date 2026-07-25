import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/estimated_delivery_window_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

/// Renders the estimated delivery time block in the checkout screen.
///
/// Displays [title] as the section heading, [label] as the main ETA text,
/// and [subtitle] as helper text. All text comes directly from the backend
/// without local calculation.
class CheckoutEtaCard extends StatelessWidget {
  const CheckoutEtaCard({super.key, required this.estimatedDeliveryWindow});

  final EstimatedDeliveryWindowEntity estimatedDeliveryWindow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.access_time_outlined,
            title: estimatedDeliveryWindow.title,
          ),
          const SizedBox(height: Spacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(Spacing.sm + 2),
              border: Border.all(color: colors.primary.withValues(alpha: 0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estimatedDeliveryWindow.label,
                  style: getBoldStyle(
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                    color: colors.onSurface,
                  ),
                ),
                if (estimatedDeliveryWindow.subtitle.isNotEmpty) ...[
                  const SizedBox(height: Spacing.xs),
                  Text(
                    estimatedDeliveryWindow.subtitle,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
