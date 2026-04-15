import 'package:flutter/material.dart';

class FavoritesNavigationService extends ChangeNotifier {
  factory FavoritesNavigationService() => _instance;

  FavoritesNavigationService._internal();
  static final FavoritesNavigationService _instance =
      FavoritesNavigationService._internal();

  void notifyTabChanged() {
    notifyListeners();
  }
}
