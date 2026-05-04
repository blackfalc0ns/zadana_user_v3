import 'package:flutter/material.dart';
import 'package:flutter_country_flags/flutter_country_flags.dart';

class LanguageFlagAvatar extends StatelessWidget {
  const LanguageFlagAvatar({
    super.key,
    required this.languageCode,
    this.size = 32,
    this.borderRadius = 16,
  });

  final String languageCode;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final country = languageCode == 'ar'
        ? Country.saudiArabia
        : Country.england;

    return FlutterCountryFlags(
      country: country,
      width: size,
      height: size,
      isCircular: true,
      borderRadius: borderRadius,
    );
  }
}
