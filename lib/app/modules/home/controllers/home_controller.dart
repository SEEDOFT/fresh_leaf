import 'package:get/get.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;

  // Mock Data
  final categories = [
    {'icon': 'leaf', 'title': 'Leafy\nGreens'},
    {'icon': 'apple', 'title': 'Root\nVeg'},
    {'icon': 'mushroom', 'title': 'Mushrooms'},
    {'icon': 'lemon', 'title': 'Citrus'},
  ].obs;

  final pickedThisMorning = [
    {
      'image':
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?q=80&w=600',
      'title': 'Heritage Carrots',
      'subtitle': 'Rainbow bunch, 500g',
      'price': '\$4.50',
      'badge': 'FRESHLY DUG',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1604544025999-4c8d550e0d5a?q=80&w=600',
      'title': 'Golden Oysters',
      'subtitle': 'Wild harvested, 200g',
      'price': '\$8.00',
      'badge': 'LIMITED',
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

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }
}
