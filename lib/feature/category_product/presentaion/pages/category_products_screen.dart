import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/feature/category/presentaion/widget/shimmer_card.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_browser_sheet.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_card.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_data.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/sub_category_chips.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/category_circle_row.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({
    super.key,
    this.category, // null = "All" mode — كل المنتجات
  });

  /// لو null يعني فتح بـ "All" وكل المنتجات
  final CategoryCircleModel? category;

  @override
  State<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen>
    with TickerProviderStateMixin {

  // ── State ─────────────────────────────────────────────────────
  CategoryCircleModel? _currentCategory; // null = All
  String _selectedSubId = 'all';
  bool _isLoading = true;

  // ── Animations ────────────────────────────────────────────────
  late final AnimationController _shimmerCtrl;
  late final Animation<double>   _shimmerAnim;
  late final AnimationController _gridCtrl;

  // ── Helpers ───────────────────────────────────────────────────
  bool get _isAllMode => _currentCategory == null;

  String get _appBarTitle =>
      _isAllMode ? 'All' : _currentCategory!.name;

  /// Sub-categories — فقط لو في category محددة
  List<SubCategoryModel> get _subCategories => _isAllMode
      ? []
      : CategoryProductData.subCategories[_currentCategory!.id] ?? [];

  /// المنتجات — لو All جمّع كل شيء، لو category فلتر
  List<CategoryProductModel> get _filteredProducts {
    if (_isAllMode) {
      // كل منتجات كل الـ categories
      return CategoryProductData.products.values
          .expand((list) => list)
          .toList();
    }
    final all =
        CategoryProductData.products[_currentCategory!.id] ?? [];
    if (_selectedSubId == 'all') return all;
    return all.where((p) => p.subCategoryId == _selectedSubId).toList();
  }

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.category; // null لو جاي من "عرض جميع المنتجات"

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );

    _gridCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _loadData();
  }

  void _loadData() {
    setState(() => _isLoading = true);
    _gridCtrl.reset();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      _shimmerCtrl.stop();
      setState(() => _isLoading = false);
      _gridCtrl.forward();
    });
  }

  void _switchCategory(CategoryCircleModel cat) {
    setState(() {
      _currentCategory = cat;
      _selectedSubId = 'all';
    });
    _shimmerCtrl.repeat();
    _loadData();
  }

  void _openSheet() => CategoryBrowserSheet.show(
        context,
        categories: kHomeCategories,
        onCategorySelected: _switchCategory,
      );

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _gridCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [_buildSliverAppBar()],
          body: Column(
            children: [
              // ── Sub-category chips (فقط لو category محددة) ──
              if (_subCategories.isNotEmpty) ...[
                const SizedBox(height: Spacing.sm),
                SubCategoryChips(
                  subCategories: _subCategories,
                  selectedId: _selectedSubId,
                  onSelected: (id) => setState(() => _selectedSubId = id),
                ),
                const SizedBox(height: Spacing.sm),
              ],

              // ── Grid ─────────────────────────────────────────
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isLoading
                      ? _buildShimmerGrid()
                      : _buildProductGrid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: 0,

      // "All ▼" أو "اسم الـ category ▼"
      title: GestureDetector(
        onTap: _openSheet,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(_appBarTitle, style: AppTextStyles.h4),
          ],
        ),
      ),

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),

     
      // "اختر الفئة" تحت العنوان
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: GestureDetector(
          onTap: _openSheet,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'اختر الفئة',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Product grid ──────────────────────────────────────────────
  Widget _buildProductGrid() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📦', style: TextStyle(fontSize: 52)),
            const SizedBox(height: Spacing.base),
            Text(
              'لا توجد منتجات في هذا القسم',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      key: ValueKey('${_currentCategory?.id ?? 'all'}_$_selectedSubId'),
      padding: const EdgeInsets.fromLTRB(
        Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.xl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
        childAspectRatio: _cardAspectRatio(context),
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final start = ((i * 60) / 600).clamp(0.0, 1.0);
        final end   = (start + 0.5).clamp(0.0, 1.0);
        final fade  = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _gridCtrl,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

        return FadeTransition(
          opacity: fade,
          child: CategoryProductCard(
            product: products[i],
            onAddTap: () {},
            onFavTap: () {},
          ),
        );
      },
    );
  }

  // ── Shimmer grid ──────────────────────────────────────────────
  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.xl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Spacing.sm,
        mainAxisSpacing: Spacing.sm,
        childAspectRatio: _cardAspectRatio(context),
      ),
      itemCount: 6,
      itemBuilder: (_, __) => ShimmerCard(animation: _shimmerAnim),
    );
  }

  double _cardAspectRatio(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return ((w - Spacing.screenH * 2 - Spacing.sm) / 2) /
        ((w - Spacing.screenH * 2 - Spacing.sm) / 2 / 0.72);
  }
}