import 'package:flutter/material.dart';

class FavoriteSyncService extends ChangeNotifier {
  static final FavoriteSyncService _instance = FavoriteSyncService._internal();

  factory FavoriteSyncService() => _instance;

  FavoriteSyncService._internal();

  String? _productId;
  bool? _isFavorite;

  String? get productId => _productId;
  bool? get isFavorite => _isFavorite;

  void notifyFavoriteChanged({
    required String productId,
    required bool isFavorite,
  }) {
    _productId = productId;
    _isFavorite = isFavorite;
    notifyListeners();
  }
}
