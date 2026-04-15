import 'package:flutter/material.dart';

class CartCountSyncService extends ChangeNotifier {
  factory CartCountSyncService() => _instance;

  CartCountSyncService._internal();
  static final CartCountSyncService _instance =
      CartCountSyncService._internal();

  int? _absoluteCount;
  int _delta = 0;
  bool _refreshRequested = false;

  int? get absoluteCount => _absoluteCount;
  int get delta => _delta;
  bool get refreshRequested => _refreshRequested;

  void incrementBy(int count) {
    _absoluteCount = null;
    _delta = count;
    _refreshRequested = false;
    notifyListeners();
  }

  void decrementBy(int count) {
    _absoluteCount = null;
    _delta = -count;
    _refreshRequested = false;
    notifyListeners();
  }

  void setCount(int count) {
    _absoluteCount = count;
    _delta = 0;
    _refreshRequested = false;
    notifyListeners();
  }

  void requestRefresh() {
    _absoluteCount = null;
    _delta = 0;
    _refreshRequested = true;
    notifyListeners();
  }
}
