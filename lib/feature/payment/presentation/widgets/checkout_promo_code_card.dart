import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/core/widgets/app_button.dart';
import 'package:zadana_user_v3/core/widgets/app_text_field.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class CheckoutPromoCodeCard extends StatefulWidget {
  const CheckoutPromoCodeCard({
    super.key,
    required this.promoCode,
    required this.currencyCode,
    required this.isLoading,
    required this.onApply,
    required this.onRemove,
  });

  final CheckoutPromoCodeEntity? promoCode;
  final String currencyCode;
  final bool isLoading;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  @override
  State<CheckoutPromoCodeCard> createState() => _CheckoutPromoCodeCardState();
}

class _CheckoutPromoCodeCardState extends State<CheckoutPromoCodeCard> {
  late final TextEditingController _promoController;

  @override
  void initState() {
    super.initState();
    _promoController = TextEditingController(text: widget.promoCode?.code ?? '');
  }

  @override
  void didUpdateWidget(covariant CheckoutPromoCodeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextCode = widget.promoCode?.code ?? '';
    if (_promoController.text != nextCode && (widget.promoCode != null || oldWidget.promoCode != null)) {
      _promoController.text = nextCode;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final promoCode = widget.promoCode;
    final currency = localizePaymentCurrency(l10n, widget.currencyCode);

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.local_offer_outlined,
            title: l10n.promo_code,
          ),
          const SizedBox(height: Spacing.md),
          if (promoCode != null)
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
                          promoCode.code,
                          style: getMediumStyle(
                            fontSize: FontSize.size14,
                            fontFamily: FontConstant.cairo,
                            color: colors.secondary,
                          ),
                        ),
                        Text(
                          '${l10n.discount} ${promoCode.discountAmount} $currency',
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.isLoading ? null : widget.onRemove,
                    icon: Icon(
                      Icons.close,
                      color: colors.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            )
          else
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
                  isLoading: widget.isLoading,
                  onPressed: () => widget.onApply(_promoController.text),
                  height: Spacing.inputHeight,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
