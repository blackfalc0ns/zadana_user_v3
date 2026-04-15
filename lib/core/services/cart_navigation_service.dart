import 'package:flutter/material.dart';

class CartNavigationService extends ChangeNotifier {
  factory CartNavigationService() => _instance;

  CartNavigationService._internal();
  static final CartNavigationService _instance =
      CartNavigationService._internal();

  void notifyTabChanged() {
    notifyListeners();
  }
}
