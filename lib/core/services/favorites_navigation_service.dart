import 'package:flutter/material.dart';

class FavoritesNavigationService extends ChangeNotifier {
  static final FavoritesNavigationService _instance =
      FavoritesNavigationService._internal();

  factory FavoritesNavigationService() => _instance;

  FavoritesNavigationService._internal();

  void notifyTabChanged() {
    notifyListeners();
  }
}
