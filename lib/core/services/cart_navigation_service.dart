import 'package:flutter/material.dart';

class CartNavigationService extends ChangeNotifier {
  factory CartNavigationService() => _instance;

  CartNavigationService._internal();
  static final CartNavigationService _instance =
      CartNavigationService._internal();

  bool _clearStateRequested = false;
  bool _reloadRequested = false;
  bool _resetBadgeRequested = false;

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

  bool consumeResetBadgeRequest() {
    final shouldResetBadge = _resetBadgeRequested;
    _resetBadgeRequested = false;
    return shouldResetBadge;
  }

  void notifyTabChanged({
    bool clearState = false,
    bool reload = true,
    bool resetBadge = false,
  }) {
    _clearStateRequested = _clearStateRequested || clearState;
    _reloadRequested = _reloadRequested || reload;
    _resetBadgeRequested =
        _resetBadgeRequested || resetBadge || clearState;
    notifyListeners();
  }
}
