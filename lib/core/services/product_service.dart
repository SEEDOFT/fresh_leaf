import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/organic_product.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProductService extends GetxService {
  ProductService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<OrganicProduct>> getProducts({
    int? categoryId,
    String? query,
    int perPage = 15,
  }) async {
    try {
      final params = <String, dynamic>{'per_page': perPage};
      if (categoryId != null) params['product_category_id'] = categoryId;
      if (query != null) params['query'] = query;

      final response = await apiClient.getRequest(
        ApiEndpoints.products,
        queryParameters: params,
      );

      // Handle simplePaginate structure
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final dataList = apiResponse.data['data'] as List<dynamic>;
        return dataList
            .map((item) => OrganicProduct.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<OrganicProduct?> getProduct(int id) async {
    try {
      final response = await apiClient.getRequest(
        ApiEndpoints.productById.replaceFirst('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        return OrganicProduct.fromMap(apiResponse.data);
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.vendorProducts,
        data: data,
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }
}
