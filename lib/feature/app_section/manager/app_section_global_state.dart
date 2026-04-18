class AppSectionGlobalState {
  const AppSectionGlobalState({
    this.isInitializing = false,
    this.isAuthResolved = false,
    this.isGuest = true,
  });

  final bool isInitializing;
  final bool isAuthResolved;
  final bool isGuest;

  AppSectionGlobalState copyWith({
    bool? isInitializing,
    bool? isAuthResolved,
    bool? isGuest,
  }) {
    return AppSectionGlobalState(
      isInitializing: isInitializing ?? this.isInitializing,
      isAuthResolved: isAuthResolved ?? this.isAuthResolved,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
