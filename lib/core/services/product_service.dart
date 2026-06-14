import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/models/vendor_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProductService extends GetxService {
  ProductService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<PaginatedResponse<VendorInventory>> getProducts({
    int? categoryId,
    String? query,
    String? province,
    String? filter,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final params = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      if (categoryId != null) params['category_id'] = categoryId;
      if (query != null) params['search'] = query;
      if (province != null) params['province'] = province;
      if (filter != null) params['filter'] = filter;

      final response = await _apiClient.getRequest(
        ApiEndpoints.products,
        queryParameters: params,
      );

      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        VendorInventory.fromMap,
      );

      if (apiResponse.isSuccess) {
        return apiResponse.data;
      }
      return PaginatedResponse.empty();
    } on Exception {
      return PaginatedResponse.empty();
    }
  }

  Future<List<VendorInventory>> getProductBySlug(String slug) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.productBySlug.replaceFirst('{slug}', slug),
      );
      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        VendorInventory.fromMap,
      );

      if (apiResponse.isSuccess) {
        return apiResponse.data.items;
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<VendorInventory?> getProduct(int id) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.productById.replaceFirst('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        return VendorInventory.fromMap(apiResponse.data);
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Future<(VendorProfile?, PaginatedResponse<VendorInventory>)> getVendorProfile(
    int id, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _apiClient.getRequest(
        '/vendors/$id',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final rawData = apiResponse.data;
        final vendorData = rawData['vendor'] as Map<String, dynamic>?;

        final vendor = vendorData != null
            ? VendorProfile.fromMap(vendorData)
            : null;

        final productsPayload = rawData['products'];
        final productsResponse = productsPayload != null
            ? ApiResponse.parsePaginated(
                {
                  'status':
                      rawData['status'] ??
                      {'success': true, 'code': 200, 'message': 'OK'},
                  'data': productsPayload,
                },
                VendorInventory.fromMap,
              ).data
            : PaginatedResponse<VendorInventory>.empty();

        return (vendor, productsResponse);
      }
      return (null, PaginatedResponse<VendorInventory>.empty());
    } on Exception {
      return (null, PaginatedResponse<VendorInventory>.empty());
    }
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.postRequest(
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
