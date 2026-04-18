import 'package:flutter/material.dart';

class CartRefreshService extends ChangeNotifier {
  factory CartRefreshService() => _instance;

  CartRefreshService._internal();

  static final CartRefreshService _instance = CartRefreshService._internal();

  bool _refreshRequested = false;

  bool consumeRefreshRequest() {
    final shouldRefresh = _refreshRequested;
    _refreshRequested = false;
    return shouldRefresh;
  }

  void notifyCartChanged() {
    _refreshRequested = true;
    notifyListeners();
  }
}
