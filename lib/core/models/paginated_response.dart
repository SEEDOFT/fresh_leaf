class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    this.nextPageUrl,
  });

  factory PaginatedResponse.empty() {
    return PaginatedResponse<T>(
      items: [],
      currentPage: 1,
    );
  }

  factory PaginatedResponse.fromMap(
    dynamic data,
    T Function(Map<String, dynamic>) itemParser,
  ) {
    var itemsList = <dynamic>[];
    var currentPage = 1;
    String? nextPageUrl;

    if (data is List) {
      itemsList = data;
    } else if (data is Map) {
      if (data.containsKey('data') && data['data'] is List) {
        itemsList = data['data'] as List<dynamic>;
      }
      currentPage = data['current_page'] as int? ?? 1;
      nextPageUrl = data['next_page_url']?.toString();
    }

    return PaginatedResponse<T>(
      items: itemsList
          .map((item) => itemParser(item as Map<String, dynamic>))
          .toList(),
      currentPage: currentPage,
      nextPageUrl: nextPageUrl,
    );
  }

  final List<T> items;
  final int currentPage;
  final String? nextPageUrl;

  bool get hasMore => nextPageUrl != null;
}
