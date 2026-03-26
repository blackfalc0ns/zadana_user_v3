import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/core/services/favorites_navigation_service.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/clear_all_dialog.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_app_bar.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_empty_state.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_grid.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_loading_skeleton.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/home_data.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<ProductModel> _favoriteProducts;
  bool _isLoading = true;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _favoriteProducts = HomeData.featured.where((p) => p.isFavorite).toList();
    FavoritesNavigationService().addListener(_startFakeLoading);
    _startFakeLoading();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    FavoritesNavigationService().removeListener(_startFakeLoading);
    super.dispose();
  }

  void _startFakeLoading() {
    _loadingTimer?.cancel();
    if (mounted) {
      setState(() => _isLoading = true);
    }
    _loadingTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  bool get _isEmpty => _favoriteProducts.isEmpty;

  void _toggleFavorite(ProductModel product) {
    final locale = context.localization;
    setState(() {
      final index = _favoriteProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _favoriteProducts.removeAt(index);
        _showSnackBar(locale.removed_from_favorites);
      }
    });
  }

  void _addToCart(ProductModel product) {
    final locale = context.localization;
    _showSnackBar(locale.product_added_to_cart(1, product.name));
  }

  void _showClearDialog() {
    showClearAllDialog(
      context: context,
      onConfirm: () => setState(() => _favoriteProducts.clear()),
    );
  }

  void _showSnackBar(String message) {
    final color = context.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: FavoritesAppBar(
          onClearAll: _isEmpty ? null : _showClearDialog,
        ),
        body: _isLoading
            ? const FavoritesLoadingSkeleton()
            : _isEmpty
                ? FavoritesEmptyState(
                    onStartShopping: () => Navigator.pop(context),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      bottom: 90,
                      left: 12,
                      right: 12,
                    ),
                    child: FavoritesGrid(
                      products: _favoriteProducts,
                      onAddToCart: _addToCart,
                      onToggleFavorite: _toggleFavorite,
                    ),
                  ),
      ),
    );
  }
}
