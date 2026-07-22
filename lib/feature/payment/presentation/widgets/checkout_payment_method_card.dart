import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/config/theme/font_manager.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/styles_manager.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';
import 'package:zadana_user_v3/feature/payment/domain/entities/checkout_summary_entity.dart';
import 'package:zadana_user_v3/feature/payment/presentation/utils/payment_ui_localizers.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/info_card_container.dart';
import 'package:zadana_user_v3/feature/payment/presentation/widgets/section_header.dart';

class CheckoutPaymentMethodCard extends StatefulWidget {
  const CheckoutPaymentMethodCard({
    super.key,
    required this.paymentMethods,
    required this.selectedMethodCode,
    required this.onMethodChanged,
  });

  final List<CheckoutPaymentMethodEntity> paymentMethods;
  final String? selectedMethodCode;
  final ValueChanged<String> onMethodChanged;

  @override
  State<CheckoutPaymentMethodCard> createState() =>
      _CheckoutPaymentMethodCardState();
}

class _CheckoutPaymentMethodCardState extends State<CheckoutPaymentMethodCard> {
  static const _applePayChannel = MethodChannel(
    'flutter.moyasar.com/apple_pay',
  );
  bool? _canUseApplePay;

  @override
  void initState() {
    super.initState();
    _checkApplePayAvailability();
  }

  Future<void> _checkApplePayAvailability() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;

    try {
      final isAvailable = await _applePayChannel.invokeMethod<bool>(
        'isApplePayAvailable',
        const {
          'supportedNetworks': ['mada', 'visa', 'masterCard'],
        },
      );
      if (mounted) setState(() => _canUseApplePay = isAvailable == true);
    } on PlatformException {
      if (mounted) setState(() => _canUseApplePay = false);
    } catch (_) {
      if (mounted) setState(() => _canUseApplePay = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visiblePaymentMethods = widget.paymentMethods
        .where(_isVisibleOnCurrentPlatform)
        .toList();

    if (visiblePaymentMethods.isEmpty) return const SizedBox.shrink();

    return InfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.payment_outlined,
            title: l10n.payment_method,
          ),
          const SizedBox(height: Spacing.md),
          for (final method in visiblePaymentMethods) ...[
            _PaymentMethodTile(
              method: method,
              isSelected: widget.selectedMethodCode == method.code,
              onTap: method.isAvailable
                  ? () => widget.onMethodChanged(method.code)
                  : null,
            ),
            if (method != visiblePaymentMethods.last)
              const SizedBox(height: Spacing.xs),
          ],
        ],
      ),
    );
  }

  bool _isVisibleOnCurrentPlatform(CheckoutPaymentMethodEntity method) {
    if (method.code.trim().toLowerCase() != 'apple_pay') return true;

    // Apple Pay must be enabled by the checkout API and can only be used on
    // iOS. Unlike other unavailable methods, it is intentionally hidden.
    return method.isAvailable &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        _canUseApplePay == true;
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.isSelected,
    this.onTap,
  });

  final CheckoutPaymentMethodEntity method;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final title = resolvePaymentMethodTitle(
      context,
      l10n,
      method.code,
      labelAr: method.labelAr,
      labelEn: method.labelEn,
    );
    final subtitle = resolvePaymentMethodSubtitle(
      context,
      l10n,
      method.code,
      descriptionAr: method.descriptionAr,
      descriptionEn: method.descriptionEn,
    );

    return Opacity(
      opacity: method.isAvailable ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Spacing.md),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.05)
                  : colors.surface,
              borderRadius: BorderRadius.circular(Spacing.md),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : colors.outline.withValues(alpha: 0.18),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary
                        : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(Spacing.sm + 2),
                  ),
                  child: Icon(
                    resolvePaymentMethodIcon(method.code),
                    color: isSelected
                        ? colors.onPrimary
                        : colors.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getBoldStyle(
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                          color: isSelected
                              ? colors.primary
                              : colors.onSurface.withValues(alpha: 0.85),
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: getRegularStyle(
                            fontSize: FontSize.size11,
                            fontFamily: FontConstant.cairo,
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!method.isAvailable)
                  Text(
                    l10n.not_available,
                    style: getMediumStyle(
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                      color: colors.error,
                    ),
                  )
                else
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? colors.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? colors.primary : colors.outline,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: colors.onPrimary, size: 12)
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
