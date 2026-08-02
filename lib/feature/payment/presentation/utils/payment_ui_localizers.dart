import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

String localizePaymentCurrency(AppLocalizations l10n, String currencyCode) {
  switch (currencyCode.trim().toUpperCase()) {
    case 'EGP':
      return l10n.egp;
    case 'SAR':
      return l10n.sar;
    default:
      return currencyCode.trim().toUpperCase();
  }
}

String localizeAddressLabel(AppLocalizations l10n, String label) {
  switch (label.trim().toLowerCase()) {
    case 'home':
      return l10n.location_address_label_home;
    case 'work':
      return l10n.location_address_label_work;
    case 'other':
      return l10n.location_address_label_other;
    default:
      return label;
  }
}

bool isArabicPaymentLocale(BuildContext context) =>
    Localizations.localeOf(context).languageCode.toLowerCase().startsWith('ar');

bool isBankTransferPaymentMethod(String code) {
  switch (code.trim().toLowerCase()) {
    case 'bank':
    case 'bank_transfer':
    case 'banktransfer':
    case 'manual_bank_transfer':
      return true;
    default:
      return false;
  }
}

bool isPickupFulfillmentType(String fulfillmentType) =>
    fulfillmentType.trim().toLowerCase() == 'pickup';

String resolveFulfillmentTitle(
  BuildContext context,
  AppLocalizations l10n,
  String fulfillmentType,
) => isPickupFulfillmentType(fulfillmentType)
    ? l10n.pickup_from_branch
    : l10n.shipping;

String resolveFulfillmentActionLabel(
  BuildContext context,
  String fulfillmentType,
) {
  final l10n = AppLocalizations.of(context)!;
  return isPickupFulfillmentType(fulfillmentType)
      ? l10n.pickup_change_branch
      : l10n.change_address;
}

String resolveMissingFulfillmentLabel(
  BuildContext context,
  String fulfillmentType,
) {
  final l10n = AppLocalizations.of(context)!;
  return isPickupFulfillmentType(fulfillmentType)
      ? l10n.pickup_select_branch_first
      : l10n.add_address;
}

String resolvePickupSelectionHint(BuildContext context) =>
    AppLocalizations.of(context)!.pickup_complete_order_unavailable;

String resolveBilingualValue(
  BuildContext context, {
  required String arabic,
  required String english,
  String fallback = '',
}) {
  final preferred = isArabicPaymentLocale(context) ? arabic : english;
  final secondary = isArabicPaymentLocale(context) ? english : arabic;
  if (preferred.trim().isNotEmpty) return preferred;
  if (secondary.trim().isNotEmpty) return secondary;
  return fallback;
}

String resolvePaymentMethodTitle(
  BuildContext context,
  AppLocalizations l10n,
  String code, {
  required String labelAr,
  required String labelEn,
}) {
  final localized = resolveBilingualValue(
    context,
    arabic: labelAr,
    english: labelEn,
  );
  if (localized.trim().isNotEmpty) return localized;
  switch (code) {
    case 'card':
      return l10n.credit_debit_card;
    case 'apple_pay':
      return l10n.apple_pay;
    case 'cash':
      return l10n.cash_on_delivery;
    case 'bank':
      return l10n.bank_transfer;
    default:
      return code;
  }
}

String resolvePaymentMethodSubtitle(
  BuildContext context,
  AppLocalizations l10n,
  String code, {
  required String descriptionAr,
  required String descriptionEn,
}) {
  final localized = resolveBilingualValue(
    context,
    arabic: descriptionAr,
    english: descriptionEn,
  );
  if (localized.trim().isNotEmpty) return localized;
  switch (code) {
    case 'card':
      return l10n.credit_card_subtitle;
    case 'apple_pay':
      return l10n.apple_pay_subtitle;
    case 'cash':
      return l10n.cash_on_delivery_subtitle;
    case 'bank':
      return l10n.bank_transfer_subtitle;
    default:
      return '';
  }
}

IconData resolvePaymentMethodIcon(String code) {
  switch (code) {
    case 'card':
      return Icons.credit_card;
    case 'apple_pay':
      // Keep Apple branding out of this tappable method selector. The actual
      // payment action uses Apple's native "Buy with Apple Pay" button.
      return Icons.account_balance_wallet_outlined;
    case 'cash':
      return Icons.money;
    case 'bank':
      return Icons.account_balance;
    default:
      return Icons.payment_outlined;
  }
}
