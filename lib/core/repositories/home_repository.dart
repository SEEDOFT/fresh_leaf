import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/product_category.dart';
import 'package:fresh_leaf/core/services/api_client.dart';

class HomeRepository {
  HomeRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.categories,
      );

      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        ProductCategory.fromMap,
      );

      if (apiResponse.isSuccess) {
        return apiResponse.data.items;
      }
      return <ProductCategory>[];
    } on Exception {
      return <ProductCategory>[];
    }
  }
}
