import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';

String localizeBrandFilterLabel(BuildContext context, String value) {
  final normalized = value.trim().toLowerCase();

  switch (normalized) {
    case 'newest':
      return context.localization.sort_newest;
    case 'price: low to high':
    case 'price low to high':
      return context.localization.sort_price_low;
    case 'price: high to low':
    case 'price high to low':
      return context.localization.sort_price_high;
    case 'best selling':
    case 'best sellers':
      return context.localization.sort_best_selling;
    case 'highest rated':
      return context.localization.sort_highest_rated;
    case 'alphabetical':
      return context.localization.sort_alphabetical;
    case 'accessories':
      return context.localization.brand_filter_accessories;
    case 'charger':
    case 'chargers':
      return context.localization.brand_filter_chargers;
    case 'phone case':
    case 'phone cases':
      return context.localization.brand_filter_phone_cases;
    case 'cable':
    case 'cables':
      return context.localization.brand_filter_cables;
    case 'adapter':
    case 'adapters':
      return context.localization.brand_filter_adapters;
    case 'headphone':
    case 'headphones':
    case 'earphone':
    case 'earphones':
      return context.localization.brand_filter_headphones;
    case 'speaker':
    case 'speakers':
      return context.localization.brand_filter_speakers;
    case 'power bank':
    case 'power banks':
      return context.localization.brand_filter_power_banks;
    case 'screen protector':
    case 'screen protectors':
      return context.localization.brand_filter_screen_protectors;
    default:
      return value;
  }
}
