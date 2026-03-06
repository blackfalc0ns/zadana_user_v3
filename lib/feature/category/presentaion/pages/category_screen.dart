import 'package:flutter/material.dart';
import 'package:zadana_user_v3/config/theme/colors.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/config/theme/text_styles.dart';
import 'package:zadana_user_v3/core/extensions/extensions.dart';
import 'package:zadana_user_v3/feature/category/domain/entities/category_model.dart';
import 'package:zadana_user_v3/feature/category/presentaion/widget/category_card.dart';
import 'package:zadana_user_v3/feature/category/presentaion/widget/category_emty_state.dart';
import 'package:zadana_user_v3/feature/category/presentaion/widget/category_search_bar.dart';
import 'package:zadana_user_v3/feature/category/presentaion/widget/shimmer_gride.dart';
// ── Dummy data ────────────────────────────────────────────────────
const List<CategoryModel> _kCategories = [
  CategoryModel(id: 'c1',  name: 'الخضروات والفواكه',  imageAsset: 'assets/images/categories/vegetables.png',    itemsCount: 142, emoji: '🥦'),
  CategoryModel(id: 'c2',  name: 'الألبان والبيض',     imageAsset: 'assets/images/categories/dairy.png',         itemsCount: 87,  emoji: '🥛'),
  CategoryModel(id: 'c3',  name: 'المخبوزات',           imageAsset: 'assets/images/categories/bakery.png',        itemsCount: 54,  emoji: '🍞'),
  CategoryModel(id: 'c4',  name: 'اللحوم والدواجن',    imageAsset: 'assets/images/categories/meat.png',          itemsCount: 63,  emoji: '🥩'),
  CategoryModel(id: 'c5',  name: 'المشروبات',           imageAsset: 'assets/images/categories/beverages.png',     itemsCount: 120, emoji: '🧃'),
  CategoryModel(id: 'c6',  name: 'منتجات المنزل',      imageAsset: 'assets/images/categories/household.png',     itemsCount: 98,  emoji: '🧴'),
  CategoryModel(id: 'c7',  name: 'العناية الشخصية',    imageAsset: 'assets/images/categories/personal_care.png', itemsCount: 75,  emoji: '🧼'),
  CategoryModel(id: 'c8',  name: 'السناكس والوجبات',   imageAsset: 'assets/images/categories/snacks.png',        itemsCount: 110, emoji: '🍿'),
  CategoryModel(id: 'c9',  name: 'القهوة والشاي',      imageAsset: 'assets/images/categories/coffee.png',        itemsCount: 46,  emoji: '☕'),
  CategoryModel(id: 'c10', name: 'المعلبات والجافة',   imageAsset: 'assets/images/categories/canned.png',        itemsCount: 133, emoji: '🥫'),
];

// ─────────────────────────────────────────────────────────────────
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {

  // ── State ─────────────────────────────────────────────────────
  bool _isLoading = true;
  List<CategoryModel> _filtered = _kCategories;

  // ── Controllers ───────────────────────────────────────────────
  final _searchCtrl = TextEditingController();

  // ── Animations ────────────────────────────────────────────────
  late final AnimationController _shimmerCtrl;   // shimmer wave
  late final AnimationController _screenCtrl;    // screen entrance
  late final AnimationController _gridCtrl;      // cards stagger
  late final Animation<double>   _shimmerAnim;
  late final Animation<double>   _screenFade;
  late final Animation<Offset>   _screenSlide;

  @override
  void initState() {
    super.initState();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );

    _screenCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _screenFade  = CurvedAnimation(parent: _screenCtrl, curve: Curves.easeOut);
    _screenSlide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _screenCtrl, curve: Curves.easeOut));

    _gridCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _screenCtrl.forward();

    // ── محاكاة تحميل 2.5 ثانية ───────────────────────────────
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      _shimmerCtrl.stop();
      setState(() => _isLoading = false);
      _gridCtrl.forward();
    });

    _searchCtrl.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim();
    setState(() {
      _filtered = q.isEmpty
          ? _kCategories
          : _kCategories.where((c) => c.name.contains(q)).toList();
    });
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _screenCtrl.dispose();
    _gridCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _CategoryAppBar(title: locale.nav_categories),
        body: FadeTransition(
          opacity: _screenFade,
          child: SlideTransition(
            position: _screenSlide,
            child: Column(
              children: [
                // ── Search ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.screenH, Spacing.base,
                    Spacing.screenH, Spacing.sm,
                  ),
                  child: CategorySearchBar(
                    controller: _searchCtrl,
                    enabled: !_isLoading,
                  ),
                ),

                // ── Content ─────────────────────────────────────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _isLoading
                        ? ShimmerGrid(
                            key: const ValueKey('shimmer'),
                            animation: _shimmerAnim,
                          )
                        : _filtered.isEmpty
                            ? CategoryEmptyState(
                                key: const ValueKey('empty'),
                                query: _searchCtrl.text,
                              )
                            : _CategoryGrid(
                                key: const ValueKey('grid'),
                                categories: _filtered,
                                gridCtrl: _gridCtrl,
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────
class _CategoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _CategoryAppBar({required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        color: AppColors.textPrimary,
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text(title, style: AppTextStyles.h4),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: Spacing.screenH),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 6, right: 6,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '3',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Category grid ─────────────────────────────────────────────────
class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    super.key,
    required this.categories,
    required this.gridCtrl,
  });

  final List<CategoryModel> categories;
  final AnimationController gridCtrl;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        Spacing.screenH, Spacing.sm, Spacing.screenH, Spacing.xl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Spacing.base,
        crossAxisSpacing: Spacing.base,
        childAspectRatio: 0.82,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) => CategoryCard(
        key: ValueKey(categories[i].id),
        category: categories[i],
        animationDelay: Duration(milliseconds: (i * 70).clamp(0, 600)),
        parentAnimation: gridCtrl,
        onTap: () {
          // TODO: context.pushNamed(AppRoutes.categoryProducts, extra: categories[i])
        },
      ),
    );
  }
}