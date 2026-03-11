import 'package:flutter/material.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_data.dart';
import 'package:zadana_user_v3/feature/category_product/presentaion/widget/category_product_model.dart';
import 'package:zadana_user_v3/feature/home/presentation/widget/category_circle_row.dart';

class CategoryProductsController extends ChangeNotifier {
  CategoryProductsController({
    required this.vsync,
    this.initialCategory,
  });

  final TickerProvider vsync;
  final CategoryCircleModel? initialCategory;

  late final AnimationController _shimmerCtrl;
  late final AnimationController _gridCtrl;
  late final Animation<double> _shimmerAnim;

  CategoryCircleModel? _currentCategory;
  String _selectedSubId = 'all';
  bool _isLoading = true;

  // Getters
  bool get isLoading => _isLoading;
  String get selectedSubId => _selectedSubId;
  CategoryCircleModel? get currentCategory => _currentCategory;
  Animation<double> get shimmerAnimation => _shimmerAnim;
  AnimationController get gridController => _gridCtrl;

  bool get _isAllMode => _currentCategory == null;
  String get appBarTitle => _isAllMode ? 'All' : _currentCategory!.name;

  List<SubCategoryModel> get subCategories => _isAllMode
      ? []
      : CategoryProductData.subCategories[_currentCategory!.id] ?? [];

  List<CategoryProductModel> get filteredProducts {
    if (_isAllMode) {
      return CategoryProductData.products.values
          .expand((list) => list)
          .toList();
    }

    final all = CategoryProductData.products[_currentCategory!.id] ?? [];
    if (_selectedSubId == 'all') return all;
    return all.where((p) => p.subCategoryId == _selectedSubId).toList();
  }

  void initialize() {
    _currentCategory = initialCategory;
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _shimmerCtrl = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _shimmerAnim = Tween<double>(begin: -1.5, end: 1.5)
        .animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    _gridCtrl = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _loadData() {
    _isLoading = true;
    notifyListeners();
    _gridCtrl.reset();

    Future.delayed(const Duration(milliseconds: 1800), () {
      _shimmerCtrl.stop();
      _isLoading = false;
      notifyListeners();
      _gridCtrl.forward();
    });
  }

  void switchCategory(CategoryCircleModel cat) {
    _currentCategory = cat;
    _selectedSubId = 'all';
    _shimmerCtrl.repeat();
    _loadData();
  }

  void selectSubCategory(String id) {
    _selectedSubId = id;
    notifyListeners();
  }

  void openCategorySheet() {
    debugPrint('Open category sheet');
  }

  void addProduct(CategoryProductModel product) {
    debugPrint('Added ${product.name} to cart');
  }

  void toggleFavorite(CategoryProductModel product) {
    debugPrint('Toggled favorite for ${product.name}');
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _gridCtrl.dispose();
    super.dispose();
  }
}