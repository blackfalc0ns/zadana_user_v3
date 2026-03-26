import 'package:flutter/material.dart';

class CartNavigationService extends ChangeNotifier {
  static final CartNavigationService _instance =
      CartNavigationService._internal();

  factory CartNavigationService() => _instance;

  CartNavigationService._internal();

  void notifyTabChanged() {
    notifyListeners();
  }
}
