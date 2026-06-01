import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/api_client.dart';

class ProductRepository {
  ProductRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<VendorInventory>> getOrganicProducts({
    int page = 1,
    int limit = 20,
    int? categoryId,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }
      if (searchQuery != null) {
        queryParams['q'] = searchQuery;
      }

      final response = await _apiClient.getRequest(
        ApiEndpoints.organicProducts,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data!['data'];
        final dataList = (rawData is Map)
            ? rawData['data'] as List<dynamic>?
            : rawData as List<dynamic>?;

        if (dataList != null) {
          return dataList
              .map(
                (json) => VendorInventory.fromMap(json as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<VendorInventory?> getOrganicProductDetail(int productId) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.organicProductDetail.replaceAll(
          '{id}',
          productId.toString(),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return VendorInventory.fromMap(
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
