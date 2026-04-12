import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_app_bar_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_banner_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_best_selling_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_brands_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_categories_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_explore_more_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_featured_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_recommended_section_state.dart';
import 'package:zadana_user_v3/feature/home/presentation/manager/home_special_offers_section_state.dart';

class HomeState {
  final HomeAppBarSectionState appBarSection;
  final HomeBannerSectionState bannerSection;
  final HomeCategoriesSectionState categoriesSection;
  final HomeBestSellingSectionState bestSellingSection;
  final HomeBrandsSectionState brandsSection;
  final HomeRecommendedSectionState recommendedSection;
  final HomeFeaturedSectionState featuredSection;
  final HomeSpecialOffersSectionState specialOffersSection;
  final HomeExploreMoreSectionState exploreMoreSection;

  const HomeState({
    this.appBarSection = const HomeAppBarSectionState(),
    this.bannerSection = const HomeBannerSectionState(),
    this.categoriesSection = const HomeCategoriesSectionState(),
    this.bestSellingSection = const HomeBestSellingSectionState(),
    this.brandsSection = const HomeBrandsSectionState(),
    this.recommendedSection = const HomeRecommendedSectionState(),
    this.featuredSection = const HomeFeaturedSectionState(),
    this.specialOffersSection = const HomeSpecialOffersSectionState(),
    this.exploreMoreSection = const HomeExploreMoreSectionState(),
  });

  bool get isLoading =>
      bannerSection.isLoading ||
      categoriesSection.isLoading ||
      bestSellingSection.isLoading ||
      brandsSection.isLoading ||
      recommendedSection.isLoading ||
      featuredSection.isLoading ||
      specialOffersSection.isLoading ||
      exploreMoreSection.isLoading;

  bool get hasAnyData {
    return (bannerSection.data?.items.isNotEmpty ?? false) ||
        (categoriesSection.data?.items.isNotEmpty ?? false) ||
        (bestSellingSection.data?.items.isNotEmpty ?? false) ||
        (brandsSection.data?.items.isNotEmpty ?? false) ||
        (recommendedSection.data?.items.isNotEmpty ?? false) ||
        (featuredSection.data?.items.isNotEmpty ?? false) ||
        (specialOffersSection.data?.items.isNotEmpty ?? false) ||
        (exploreMoreSection.data?.items.isNotEmpty ?? false);
  }

  Failure? get firstFailure {
    return bannerSection.failure ??
        categoriesSection.failure ??
        bestSellingSection.failure ??
        brandsSection.failure ??
        recommendedSection.failure ??
        featuredSection.failure ??
        specialOffersSection.failure ??
        exploreMoreSection.failure;
  }

  HomeState copyWith({
    HomeAppBarSectionState? appBarSection,
    HomeBannerSectionState? bannerSection,
    HomeCategoriesSectionState? categoriesSection,
    HomeBestSellingSectionState? bestSellingSection,
    HomeBrandsSectionState? brandsSection,
    HomeRecommendedSectionState? recommendedSection,
    HomeFeaturedSectionState? featuredSection,
    HomeSpecialOffersSectionState? specialOffersSection,
    HomeExploreMoreSectionState? exploreMoreSection,
  }) {
    return HomeState(
      appBarSection: appBarSection ?? this.appBarSection,
      bannerSection: bannerSection ?? this.bannerSection,
      categoriesSection: categoriesSection ?? this.categoriesSection,
      bestSellingSection: bestSellingSection ?? this.bestSellingSection,
      brandsSection: brandsSection ?? this.brandsSection,
      recommendedSection: recommendedSection ?? this.recommendedSection,
      featuredSection: featuredSection ?? this.featuredSection,
      specialOffersSection: specialOffersSection ?? this.specialOffersSection,
      exploreMoreSection: exploreMoreSection ?? this.exploreMoreSection,
    );
  }
}
