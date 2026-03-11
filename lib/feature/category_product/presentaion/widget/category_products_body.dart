import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_products_grid.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_products_shimmer.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/sub_category_chips.dart';

class CategoryProductsBody extends StatelessWidget {
  const CategoryProductsBody({
    super.key,
    required this.subCategories,
    required this.selectedSubId,
    required this.isLoading,
    required this.products,
    required this.shimmerAnimation,
    required this.gridController,
    required this.onSubCategorySelected,
    required this.onProductAdd,
    required this.onProductFavorite,
  });

  final List<SubCategoryModel> subCategories;
  final String selectedSubId;
  final bool isLoading;
  final List<CategoryProductModel> products;
  final Animation<double> shimmerAnimation;
  final AnimationController gridController;
  final ValueChanged<String> onSubCategorySelected;
  final ValueChanged<CategoryProductModel> onProductAdd;
  final ValueChanged<CategoryProductModel> onProductFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (subCategories.isNotEmpty) ...[
          const SizedBox(height: Spacing.sm),
          SubCategoryChips(
            subCategories: subCategories,
            selectedId: selectedSubId,
            onSelected: onSubCategorySelected,
          ),
          const SizedBox(height: Spacing.sm),
        ],
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLoading
                ? CategoryProductsShimmer(animation: shimmerAnimation)
                : CategoryProductsGrid(
                    products: products,
                    gridController: gridController,
                    selectedSubId: selectedSubId,
                    onProductAdd: onProductAdd,
                    onProductFavorite: onProductFavorite,
                  ),
          ),
        ),
      ],
    );
  }
}