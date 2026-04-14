sealed class ProductSearchEvent {
  const ProductSearchEvent();
}

class ProductSearchQueryChangedEvent extends ProductSearchEvent {
  const ProductSearchQueryChangedEvent(this.query);

  final String query;
}

class ProductSearchSubmitEvent extends ProductSearchEvent {
  const ProductSearchSubmitEvent(this.query);

  final String query;
}

class ProductSearchLoadMoreEvent extends ProductSearchEvent {
  const ProductSearchLoadMoreEvent();
}

class ProductSearchRefreshEvent extends ProductSearchEvent {
  const ProductSearchRefreshEvent();
}

class ProductSearchRetryEvent extends ProductSearchEvent {
  const ProductSearchRetryEvent();
}
