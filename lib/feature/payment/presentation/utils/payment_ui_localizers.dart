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

bool isArabicPaymentLocale(BuildContext context) {
  return Localizations.localeOf(
    context,
  ).languageCode.toLowerCase().startsWith('ar');
}

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

bool isPickupFulfillmentType(String fulfillmentType) {
  return fulfillmentType.trim().toLowerCase() == 'pickup';
}

String resolveFulfillmentTitle(
  BuildContext context,
  AppLocalizations l10n,
  String fulfillmentType,
) {
  return isPickupFulfillmentType(fulfillmentType)
      ? (isArabicPaymentLocale(context)
            ? 'الاستلام من الفرع'
            : 'Pickup from branch')
      : l10n.shipping;
}

String resolveFulfillmentActionLabel(
  BuildContext context,
  String fulfillmentType,
) {
  return isPickupFulfillmentType(fulfillmentType)
      ? (isArabicPaymentLocale(context) ? 'تغيير الفرع' : 'Change branch')
      : AppLocalizations.of(context)!.change_address;
}

String resolveMissingFulfillmentLabel(
  BuildContext context,
  String fulfillmentType,
) {
  return isPickupFulfillmentType(fulfillmentType)
      ? (isArabicPaymentLocale(context)
            ? 'لازم تختار فرع الاستلام أولاً علشان تكمّل الطلب'
            : 'Select a pickup branch first to complete the order')
      : AppLocalizations.of(context)!.add_address;
}

String resolvePickupSelectionHint(BuildContext context) {
  return isArabicPaymentLocale(context)
      ? 'زر إكمال الطلب غير متاح لأن فرع الاستلام لم يتم تحديده بعد.'
      : 'Complete order is unavailable until a pickup branch is selected.';
}

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
      return Icons.apple;
    case 'cash':
      return Icons.money;
    case 'bank':
      return Icons.account_balance;
    default:
      return Icons.payment_outlined;
  }
}
