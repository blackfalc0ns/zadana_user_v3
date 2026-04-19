class AppSectionGlobalState {
  const AppSectionGlobalState({
    this.isInitializing = false,
    this.isAuthResolved = false,
    this.isGuest = true,
    this.cartCount = 0,
    this.favoritesCount = 0,
  });

  final bool isInitializing;
  final bool isAuthResolved;
  final bool isGuest;
  final int cartCount;
  final int favoritesCount;

  AppSectionGlobalState copyWith({
    bool? isInitializing,
    bool? isAuthResolved,
    bool? isGuest,
    int? cartCount,
    int? favoritesCount,
  }) {
    return AppSectionGlobalState(
      isInitializing: isInitializing ?? this.isInitializing,
      isAuthResolved: isAuthResolved ?? this.isAuthResolved,
      isGuest: isGuest ?? this.isGuest,
      cartCount: cartCount ?? this.cartCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
    );
  }
}
