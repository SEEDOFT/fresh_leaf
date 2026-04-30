import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/organic_category.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class CategoryService extends GetxService {
  CategoryService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<OrganicCategory>> getCategories() async {
    try {
      final response = await apiClient.getRequest(ApiEndpoints.categories);
      final apiResponse = ApiResponse.parseList(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.data.map(OrganicCategory.fromMap).toList();
      }
      return [];
    } on Exception catch (_) {
      return [];
    }
  }

  Future<OrganicCategory?> getCategory(
    String slug, {
    bool includeProducts = false,
  }) async {
    try {
      final response = await apiClient.getRequest(
        ApiEndpoints.categoryBySlug.replaceFirst('{slug}', slug),
        queryParameters: {'include_products': includeProducts},
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        return OrganicCategory.fromMap(apiResponse.data);
      }
      return null;
    } on Exception catch (_) {
      return null;
    }
  }
}
