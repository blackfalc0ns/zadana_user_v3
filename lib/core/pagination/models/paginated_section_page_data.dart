class PaginatedSectionPageData<T> {
  const PaginatedSectionPageData({
    required this.title,
    required this.totalCount,
    required this.items,
  });
  final String title;
  final int totalCount;
  final List<T> items;
}
