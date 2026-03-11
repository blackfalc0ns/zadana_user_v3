import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_products_controller.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_products_app_bar.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_products_body.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/category_circle_row.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, this.category});

  final CategoryCircleModel? category;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen>
    with TickerProviderStateMixin {
  late final CategoryProductsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CategoryProductsController(
      vsync: this,
      initialCategory: widget.category,
    );
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return NestedScrollView(
              headerSliverBuilder: (_, _) => [
                CategoryProductsAppBar(
                  title: _controller.appBarTitle,
                  onCategoryTap: _controller.openCategorySheet,
                ),
              ],
              body: CategoryProductsBody(
                subCategories: _controller.subCategories,
                selectedSubId: _controller.selectedSubId,
                isLoading: _controller.isLoading,
                products: _controller.filteredProducts,
                shimmerAnimation: _controller.shimmerAnimation,
                gridController: _controller.gridController,
                onSubCategorySelected: _controller.selectSubCategory,
                onProductAdd: _controller.addProduct,
                onProductFavorite: _controller.toggleFavorite,
              ),
            );
          },
        ),
      ),
    );
  }
}