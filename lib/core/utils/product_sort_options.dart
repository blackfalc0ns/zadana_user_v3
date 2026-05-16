import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

List<Map<String, dynamic>> resolveProductSortOptions(
  AppLocalizations l10n, {
  Iterable<Map<String, dynamic>>? rawOptions,
}) {
  final options = rawOptions?.toList(growable: false) ?? const [];

  // If server provides sort options, use them directly with their labels.
  if (options.isNotEmpty) {
    return options
        .where((option) => (option['value'] as String?)?.trim().isNotEmpty ?? false)
        .map((option) {
          final value = (option['value'] as String?)?.trim() ?? '';
          final title = (option['title'] as String?)?.trim() ??
              (option['label'] as String?)?.trim() ??
              value;
          return <String, dynamic>{
            'value': value,
            'title': title,
            'subtitle': null,
          };
        })
        .toList(growable: false);
  }

  // Fallback: static localized options when server provides nothing.
  return [
    {'value': 'newest', 'title': l10n.sort_newest, 'subtitle': null},
    {'value': 'price_low_high', 'title': l10n.sort_price_low, 'subtitle': null},
    {'value': 'price_high_low', 'title': l10n.sort_price_high, 'subtitle': null},
    {'value': 'best_selling', 'title': l10n.sort_best_selling, 'subtitle': null},
    {'value': 'highest_rated', 'title': l10n.sort_highest_rated, 'subtitle': null},
    {'value': 'alphabetical', 'title': l10n.sort_alphabetical, 'subtitle': null},
  ];
}
