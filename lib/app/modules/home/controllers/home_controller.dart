import 'package:get/get.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;

  // Mock Data
  final categories = [
    {'icon': 'leaf', 'title': 'home_category_leafy_greens'},
    {'icon': 'apple', 'title': 'home_category_root_veg'},
    {'icon': 'mushroom', 'title': 'home_category_mushrooms'},
    {'icon': 'lemon', 'title': 'home_category_citrus'},
  ].obs;

  final pickedThisMorning = [
    {
      'image':
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?q=80&w=600',
      'title': 'home_product_heritage_carrots_title',
      'subtitle': 'home_product_heritage_carrots_subtitle',
      'price': '\$4.50',
      'badge': 'home_product_heritage_carrots_badge',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1604544025999-4c8d550e0d5a?q=80&w=600',
      'title': 'home_product_golden_oysters_title',
      'subtitle': 'home_product_golden_oysters_subtitle',
      'price': '\$8.00',
      'badge': 'home_product_golden_oysters_badge',
    },
  ].obs;

  List<Map<String, dynamic>> get filteredPickedThisMorning {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return pickedThisMorning.cast<Map<String, dynamic>>();
    }

    return pickedThisMorning
        .where((item) {
          final title = (item['title'] ?? '').toString().toLowerCase();
          final subtitle = (item['subtitle'] ?? '').toString().toLowerCase();
          final badge = (item['badge'] ?? '').toString().toLowerCase();
          return title.contains(query) ||
              subtitle.contains(query) ||
              badge.contains(query);
        })
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<void> refreshHome() async {}

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }
}
