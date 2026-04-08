import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/home/domain/entities/home_special_offers_entity.dart';

class HomeSpecialOffersSectionState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? failure;
  final HomeSpecialOffersEntity? data;

  const HomeSpecialOffersSectionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.failure,
    this.data,
  });

  HomeSpecialOffersSectionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? failure,
    bool clearFailure = false,
    HomeSpecialOffersEntity? data,
    bool clearData = false,
  }) {
    return HomeSpecialOffersSectionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      failure: clearFailure ? null : (failure ?? this.failure),
      data: clearData ? null : (data ?? this.data),
    );
  }
}
