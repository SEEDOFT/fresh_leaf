import 'package:fresh_leaf/core/models/home_category.dart';
import 'package:fresh_leaf/core/models/home_product.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxString _searchQuery = ''.obs;

  String get searchQuery => _searchQuery.value;
  set searchQuery(String value) => _searchQuery.value = value;

  // Mock Data
  final RxList<HomeCategory> categories = <HomeCategory>[
    const HomeCategory(
      icon: HomeCategoryIcon.leaf,
      titleKey: 'home_category_leafy_greens',
    ),
    const HomeCategory(
      icon: HomeCategoryIcon.apple,
      titleKey: 'home_category_root_veg',
    ),
    const HomeCategory(
      icon: HomeCategoryIcon.mushroom,
      titleKey: 'home_category_mushrooms',
    ),
    const HomeCategory(
      icon: HomeCategoryIcon.lemon,
      titleKey: 'home_category_citrus',
    ),
  ].obs;

  final RxList<HomeProduct> pickedThisMorning = <HomeProduct>[
    const HomeProduct(
      image:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?q=80&w=600',
      title: 'home_product_heritage_carrots_title',
      subtitle: 'home_product_heritage_carrots_subtitle',
      priceText: r'$4.50',
      badge: 'home_product_heritage_carrots_badge',
      description: 'seasonal_pick_description',
      tags: ['organic', 'fresh'],
      origin: 'local_farm',
      harvest: 'harvested_this_week',
      storage: 'refrigerate_extend_freshness',
    ),
    const HomeProduct(
      image:
          'https://images.unsplash.com/photo-1604544025999-4c8d550e0d5a?q=80&w=600',
      title: 'home_product_golden_oysters_title',
      subtitle: 'home_product_golden_oysters_subtitle',
      priceText: r'$8.00',
      badge: 'home_product_golden_oysters_badge',
      description: 'seasonal_pick_description',
      tags: ['organic', 'fresh'],
      origin: 'local_farm',
      harvest: 'harvested_this_week',
      storage: 'refrigerate_extend_freshness',
    ),
  ].obs;

  List<HomeProduct> get filteredPickedThisMorning {
    final query = _searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return pickedThisMorning.toList();
    }

    return pickedThisMorning
        .where((item) {
          final title = item.title.toLowerCase();
          final subtitle = item.subtitle.toLowerCase();
          final badge = item.badge.toLowerCase();
          return title.contains(query) ||
              subtitle.contains(query) ||
              badge.contains(query);
        })
        .toList();
  }

  Future<void> refreshHome() async {}
}
