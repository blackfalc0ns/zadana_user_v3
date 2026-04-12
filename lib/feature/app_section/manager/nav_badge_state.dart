class NavBadgeState {
  const NavBadgeState({
    this.cartCount = 0,
    this.favoritesCount = 0,
  });

  final int cartCount;
  final int favoritesCount;

  NavBadgeState copyWith({
    int? cartCount,
    int? favoritesCount,
  }) {
    return NavBadgeState(
      cartCount: cartCount ?? this.cartCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
    );
  }
}
