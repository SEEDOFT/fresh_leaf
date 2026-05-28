import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:get/get.dart';

mixin PaginatedListMixin<T> on GetxController {
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;

  int _currentPage = 1;

  Future<PaginatedResponse<T>> fetchPage(int page);

  Future<void> loadInitial() async {
    isLoading.value = true;
    _currentPage = 1;

    try {
      final response = await fetchPage(_currentPage);
      items.assignAll(response.items);
      hasMore.value = response.hasMore;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || isLoading.value) {
      return;
    }

    isLoadingMore.value = true;
    try {
      final nextPage = _currentPage + 1;
      final response = await fetchPage(nextPage);

      if (response.items.isNotEmpty) {
        items.addAll(response.items);
        _currentPage = nextPage;
      }

      hasMore.value = response.hasMore;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshList() async {
    await loadInitial();
  }
}
