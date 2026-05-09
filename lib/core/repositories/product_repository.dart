import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/organic_product.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProductRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<OrganicProduct>> getOrganicProducts({
    int page = 1,
    int limit = 20,
    int? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }

      final response = await _apiClient.getRequest(
        ApiEndpoints.organicProducts,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data
              .map(
                (json) => OrganicProduct.fromMap(json as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<OrganicProduct?> getOrganicProductDetail(int productId) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.organicProductDetail.replaceAll(
          '{id}',
          productId.toString(),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return OrganicProduct.fromMap(
          response.data!['data'] as Map<String, dynamic>,
        );
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Future<List<ProductInfo>> searchProducts(
    String query, {
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.search,
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data
              .map((json) => ProductInfo.fromMap(json as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<List<ProductInfo>> getWishlist() async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.wishlist,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['data'] as List?;
        if (data != null) {
          return data
              .map((json) => ProductInfo.fromMap(json as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on Exception {
      return [];
    }
  }
}
