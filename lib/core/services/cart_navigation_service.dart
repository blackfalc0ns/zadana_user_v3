import 'package:flutter/material.dart';

class CartNavigationService extends ChangeNotifier {
  factory CartNavigationService() => _instance;

  CartNavigationService._internal();
  static final CartNavigationService _instance =
      CartNavigationService._internal();

  bool _clearStateRequested = false;
  bool _reloadRequested = false;

  bool consumeClearStateRequest() {
    final shouldClear = _clearStateRequested;
    _clearStateRequested = false;
    return shouldClear;
  }

  bool consumeReloadRequest() {
    final shouldReload = _reloadRequested;
    _reloadRequested = false;
    return shouldReload;
  }

  void notifyTabChanged({bool clearState = false, bool reload = true}) {
    _clearStateRequested = _clearStateRequested || clearState;
    _reloadRequested = _reloadRequested || reload;
    notifyListeners();
  }
}
