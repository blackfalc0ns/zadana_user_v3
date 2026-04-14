class PaginatedSectionPageData<T> {
  final String title;
  final int totalCount;
  final List<T> items;

  const PaginatedSectionPageData({
    required this.title,
    required this.totalCount,
    required this.items,
  });
}
