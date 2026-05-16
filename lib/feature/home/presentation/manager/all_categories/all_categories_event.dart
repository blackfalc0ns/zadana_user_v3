sealed class AllCategoriesEvent {
  const AllCategoriesEvent();
}

class AllCategoriesLoadEvent extends AllCategoriesEvent {
  const AllCategoriesLoadEvent();
}

class AllCategoriesLoadMoreEvent extends AllCategoriesEvent {
  const AllCategoriesLoadMoreEvent();
}

class AllCategoriesRefreshEvent extends AllCategoriesEvent {
  const AllCategoriesRefreshEvent();
}
