class Pagination {
  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;
}

class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.pagination,
  });

  final List<T> items;
  final Pagination pagination;
}
