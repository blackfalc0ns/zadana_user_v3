import 'package:zadana_user_v3/core/l10n/translations/app_localizations.dart';

List<Map<String, dynamic>> resolveProductSortOptions(
  AppLocalizations l10n, {
  Iterable<Map<String, dynamic>>? rawOptions,
}) {
  final options = rawOptions?.toList(growable: false) ?? const [];
  final localizedOptions = <String, Map<String, dynamic>>{
    'newest': {'value': 'newest', 'title': l10n.sort_newest, 'subtitle': null},
    'price_low': {
      'value': 'price_low',
      'title': l10n.sort_price_low,
      'subtitle': null,
    },
    'price_high': {
      'value': 'price_high',
      'title': l10n.sort_price_high,
      'subtitle': null,
    },
    'best_selling': {
      'value': 'best_selling',
      'title': l10n.sort_best_selling,
      'subtitle': null,
    },
    'highest_rated': {
      'value': 'highest_rated',
      'title': l10n.sort_highest_rated,
      'subtitle': null,
    },
    'alphabetical': {
      'value': 'alphabetical',
      'title': l10n.sort_alphabetical,
      'subtitle': null,
    },
  };

  if (options.isEmpty) {
    return localizedOptions.values.toList(growable: false);
  }

  final optionsByValue = <String, Map<String, dynamic>>{};
  final unknownOptions = <Map<String, dynamic>>[];

  for (final option in options) {
    final value = (option['value'] as String?)?.trim() ?? '';
    if (value.isEmpty) {
      continue;
    }

    if (localizedOptions.containsKey(value)) {
      optionsByValue[value] = option;
      continue;
    }

    unknownOptions.add({
      'value': value,
      'title': ((option['title'] as String?) ?? value).trim(),
      'subtitle': null,
    });
  }

  final orderedOptions = localizedOptions.entries
      .where((entry) => optionsByValue.containsKey(entry.key))
      .map((entry) => entry.value)
      .toList(growable: true);

  orderedOptions.addAll(unknownOptions);
  return orderedOptions;
}
