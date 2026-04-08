sealed class HomeEvent {
  const HomeEvent();
}

class HomeLoadEvent extends HomeEvent {
  const HomeLoadEvent();
}

class HomeBannerLoadEvent extends HomeEvent {
  const HomeBannerLoadEvent();
}

class HomeCategoriesLoadEvent extends HomeEvent {
  const HomeCategoriesLoadEvent();
}

class HomeBestSellingLoadEvent extends HomeEvent {
  const HomeBestSellingLoadEvent();
}

class HomeRetryEvent extends HomeEvent {
  const HomeRetryEvent();
}

class HomeBannerRetryEvent extends HomeEvent {
  const HomeBannerRetryEvent();
}

class HomeCategoriesRetryEvent extends HomeEvent {
  const HomeCategoriesRetryEvent();
}

class HomeBestSellingRetryEvent extends HomeEvent {
  const HomeBestSellingRetryEvent();
}

class HomeResetEvent extends HomeEvent {
  const HomeResetEvent();
}
