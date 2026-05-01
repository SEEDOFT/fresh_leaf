import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/home_category.dart';
import 'package:fresh_leaf/core/models/home_product.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class HomeRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<HomeCategory>> getCategories() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.homeCategories,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data
              .map((json) => HomeCategory.fromMap(json as Map<String, dynamic>))
              .toList();
        }
      }
      return getMockCategories();
    } on Exception {
      return getMockCategories();
    }
  }

  Future<List<HomeProduct>> getFeaturedProducts() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.homeProducts,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data
              .map((json) => HomeProduct.fromMap(json as Map<String, dynamic>))
              .toList();
        }
      }
      return getMockProducts();
    } on Exception {
      return getMockProducts();
    }
  }

  List<HomeCategory> getMockCategories() {
    return const [
      HomeCategory(
        icon: HomeCategoryIcon.leaf,
        titleKey: 'home_category_leafy_greens',
      ),
      HomeCategory(
        icon: HomeCategoryIcon.rootAndTuber,
        titleKey: 'home_category_root_veg',
      ),
      HomeCategory(
        icon: HomeCategoryIcon.bulmAndStem,
        titleKey: 'home_category_mushrooms',
      ),
      HomeCategory(
        icon: HomeCategoryIcon.legume,
        titleKey: 'home_category_citrus',
      ),
      HomeCategory(
        icon: HomeCategoryIcon.indigenousAndWild,
        titleKey: 'home_category_indigenous_and_wild',
      ),
    ];
  }

  List<HomeProduct> getMockProducts() {
    return const [
      HomeProduct(
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
        shareSlug: 'heritage-carrots',
      ),
      HomeProduct(
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
        shareSlug: 'golden-oysters',
      ),
    ];
  }
}
