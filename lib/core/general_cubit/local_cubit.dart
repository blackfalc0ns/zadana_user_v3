import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/services/language_service.dart';
import 'package:zadana_user_v3/core/utils/constants.dart';

import 'general_state.dart';

@lazySingleton
class LocaleThemeCubit extends Cubit<LocaleThemeState> {
  LocaleThemeCubit(this._languageService)
    : super(
        LocaleThemeState(
          locale: Locale(_languageService.getLanguageCode()),
          isDark: false,
        ),
      );

  final LanguageService _languageService;

  Future<void> setLocale(String languageCode) async {
    if (state.locale.languageCode == languageCode) {
      return;
    }

    await _languageService.saveLanguageCode(languageCode);
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  Future<void> setArabic() => setLocale(AppConstants.arKey);

  Future<void> setEnglish() => setLocale(AppConstants.enKey);

  void toggleTheme() {
    emit(state.copyWith(isDark: !state.isDark));
  }
}
