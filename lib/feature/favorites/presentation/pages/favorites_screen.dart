import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/favorites/data/favorites_data.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_empty_state.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_grid.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/favorites_app_bar.dart';
import 'package:zadana_user_v3/feature/favorites/presentation/widgets/clear_all_dialog.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<ProductModel> _products;

  @override
  void initState() {
    super.initState();
    _products = List.from(FavoritesData.favoriteProducts);
  }

  void _toggleFavorite(ProductModel product) {
    setState(() {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) _products[index] = _products[index].copyWith(isFavorite: false);
    });
    _showSnackBar('تم إزالة ${product.name} من المفضلة', AppColors.error);
  }

  void _addToCart(ProductModel product) {
    _showSnackBar('تم إضافة ${product.name} إلى السلة', AppColors.success);
  }

  void _clearAll() {
    setState(() {
      _products = _products.map((p) => p.copyWith(isFavorite: false)).toList();
    });
    _showSnackBar('تم مسح جميع المنتجات من المفضلة', AppColors.error);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)),
    );
  }

  void _showClearDialog() => showDialog(
    context: context,
    builder: (context) => ClearAllDialog(onConfirm: _clearAll),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: FavoritesAppBar(
          hasProducts: _products.isNotEmpty,
          onClearAll: _showClearDialog,
        ),
        body: _products.isEmpty
            ? const FavoritesEmptyState()
            : Padding(
                padding: const EdgeInsets.all(Spacing.base),
                child: FavoritesGrid(
                  products: _products,
                  onAddToCart: _addToCart,
                  onToggleFavorite: _toggleFavorite,
                ),
              ),
      ),
    );
  }
}
