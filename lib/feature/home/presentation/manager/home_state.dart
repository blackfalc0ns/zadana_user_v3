import 'package:zadana_user_v3/feature/home/presentation/manager/home_app_bar_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_banner_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_best_selling_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_categories_section_state.dart';

class HomeState {
  final HomeAppBarSectionState appBarSection;
  final HomeBannerSectionState bannerSection;
  final HomeCategoriesSectionState categoriesSection;
  final HomeBestSellingSectionState bestSellingSection;

  const HomeState({
    this.appBarSection = const HomeAppBarSectionState(),
    this.bannerSection = const HomeBannerSectionState(),
    this.categoriesSection = const HomeCategoriesSectionState(),
    this.bestSellingSection = const HomeBestSellingSectionState(),
  });

  HomeState copyWith({
    HomeAppBarSectionState? appBarSection,
    HomeBannerSectionState? bannerSection,
    HomeCategoriesSectionState? categoriesSection,
    HomeBestSellingSectionState? bestSellingSection,
  }) {
    return HomeState(
      appBarSection: appBarSection ?? this.appBarSection,
      bannerSection: bannerSection ?? this.bannerSection,
      categoriesSection: categoriesSection ?? this.categoriesSection,
      bestSellingSection: bestSellingSection ?? this.bestSellingSection,
    );
  }
}
