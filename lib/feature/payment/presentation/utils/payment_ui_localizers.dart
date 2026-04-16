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

String resolvePaymentMethodTitle(AppLocalizations l10n, String code, String label) {
  if (label.trim().isNotEmpty) return label;

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

String resolvePaymentMethodSubtitle(AppLocalizations l10n, String code) {
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
