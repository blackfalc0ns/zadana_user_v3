import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class PromoCodeCard extends StatefulWidget {
  const PromoCodeCard({super.key});

  @override
  State<PromoCodeCard> createState() => _PromoCodeCardState();
}

class _PromoCodeCardState extends State<PromoCodeCard> {
  final TextEditingController _promoController = TextEditingController();
  bool _isApplied = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.local_offer_outlined,
            title: l10n.promo_code,
          ),
          const SizedBox(height: Spacing.md),

          if (_isApplied) ...[
            // Applied Promo Code
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Spacing.sm),
                border: Border.all(
                  color: colors.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: colors.secondary,
                    size: Spacing.iconMd,
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.promo_code,
                          style: getMediumStyle(
                            fontSize: FontSize.size14,
                            fontFamily: FontConstant.cairo,
                            color: colors.secondary,
                          ),
                        ),
                        Text(
                          'SAVE15 - ${l10n.discount} 15 ${l10n.sar}',
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _removePromoCode,
                    icon: Icon(
                      Icons.close,
                      color: colors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Promo Code Input
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _promoController,
                    hint: l10n.promo_code,
                    prefixIcon: const Icon(Icons.local_offer_outlined),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                AppButton.filled(
                  text: l10n.apply,
                  isExpanded: false,
                  isLoading: _isLoading,
                  onPressed: _applyPromoCode,
                  height: Spacing.inputHeight,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _applyPromoCode() {
    if (_promoController.text.trim().isEmpty) return;

    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isApplied = true;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.promo_code,
              style: getRegularStyle(
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
                color: colors.onSecondary,
              ),
            ),
            backgroundColor: colors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Spacing.sm),
            ),
          ),
        );
      }
    });
  }

  void _removePromoCode() {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    setState(() {
      _isApplied = false;
      _promoController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.cancel,
          style: getRegularStyle(
            fontSize: FontSize.size14,
            fontFamily: FontConstant.cairo,
            color: colors.onSurfaceVariant,
          ),
        ),
        backgroundColor: colors.surfaceContainerHighest,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.sm),
        ),
      ),
    );
  }
}
