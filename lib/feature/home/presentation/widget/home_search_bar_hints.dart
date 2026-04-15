import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

class HomeSearchBarHints {
  static List<(String, Color)> resolve(BuildContext context) {
    final l10n = context.localization;

    return [
      (l10n.home_search_hint_dairy, Colors.white),
      (l10n.home_search_hint_vegetables, Colors.greenAccent),
      (l10n.home_search_hint_fruits, Colors.orangeAccent),
      (l10n.home_search_hint_meat, Colors.redAccent),
      (l10n.home_search_hint_drinks, Colors.blueAccent),
      (l10n.home_search_hint_bakery, Colors.amberAccent),
      (l10n.home_search_hint_spices, Colors.brown),
      (l10n.home_search_hint_cleaning, Colors.cyanAccent),
      (l10n.home_search_hint_oils, Colors.yellowAccent),
      (l10n.home_search_hint_nuts, Colors.deepOrangeAccent),
      (l10n.home_search_hint_canned, Colors.lightBlueAccent),
      (l10n.home_search_hint_baby, Colors.pinkAccent),
    ];
  }
}
