import 'package:flutter/material.dart';

class CartNavigationService extends ChangeNotifier {
  factory CartNavigationService() => _instance;

  CartNavigationService._internal();
  static final CartNavigationService _instance =
      CartNavigationService._internal();

  bool _clearStateRequested = false;

  bool consumeClearStateRequest() {
    final shouldClear = _clearStateRequested;
    _clearStateRequested = false;
    return shouldClear;
  }

  void notifyTabChanged({bool clearState = false}) {
    _clearStateRequested = _clearStateRequested || clearState;
    notifyListeners();
  }
}
