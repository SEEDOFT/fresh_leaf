import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/product_category.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class HomeRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.categories,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data
              .map(
                (json) => ProductCategory.fromMap(json as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return getMockCategories();
    } on Exception {
      return getMockCategories();
    }
  }

  List<ProductCategory> getMockCategories() {
    return [
      const ProductCategory(
        id: 1,
        icon: ProductCategoryIcon.leaf,
        name: 'Leafy Vegetables',
      ),
      const ProductCategory(
        id: 3,
        icon: ProductCategoryIcon.rootAndTuber,
        name: 'Root & Tuber Crops',
      ),
      const ProductCategory(
        id: 4,
        icon: ProductCategoryIcon.bulbAndStem,
        name: 'Bulb & Stem Vegetables',
      ),
      const ProductCategory(
        id: 5,
        icon: ProductCategoryIcon.legume,
        name: 'Legumes',
      ),
      const ProductCategory(
        id: 6,
        icon: ProductCategoryIcon.indigenousAndWild,
        name: 'Indigenous & Wild Plants',
      ),
    ];
  }
}
