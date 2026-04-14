enum HomeProductSectionTheme { classic, compact, showcase }

HomeProductSectionTheme parseHomeProductSectionTheme(String? value) {
  final normalized = value?.trim().toLowerCase() ?? '';
  final compactNormalized = normalized.replaceAll(RegExp(r'[\s_-]+'), '');
  if (normalized.isEmpty) return HomeProductSectionTheme.classic;

  if (normalized == '3' ||
      compactNormalized.contains('theme3') ||
      normalized.contains('showcase') ||
      normalized.contains('grid')) {
    return HomeProductSectionTheme.showcase;
  }

  if (normalized == '2' ||
      compactNormalized.contains('theme2') ||
      normalized.contains('recommended') ||
      normalized.contains('compact')) {
    return HomeProductSectionTheme.compact;
  }

  return HomeProductSectionTheme.classic;
}
