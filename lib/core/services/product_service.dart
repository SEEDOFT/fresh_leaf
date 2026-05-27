import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/models/vendor_profile.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProductService extends GetxService {
  ProductService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<VendorInventory>> getProducts({
    int? categoryId,
    String? query,
    String? province,
    int perPage = 15,
  }) async {
    try {
      final params = <String, dynamic>{'per_page': perPage};
      if (categoryId != null) params['category_id'] = categoryId;
      if (query != null) params['search'] = query;
      if (province != null) params['province'] = province;

      final response = await apiClient.getRequest(
        ApiEndpoints.products,
        queryParameters: params,
      );

      // Handle simplePaginate structure
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final rawData = apiResponse.data;
        final dataList =
            (rawData['vendor_inventories'] ??
                    rawData['products'] ??
                    rawData['data'])
                as List<dynamic>?;

        if (dataList != null) {
          return dataList
              .map(
                (item) => VendorInventory.fromMap(item as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<VendorInventory?> getProduct(int id) async {
    try {
      final response = await apiClient.getRequest(
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

  Future<(VendorProfile?, List<VendorInventory>)> getVendorProfile(
    int id,
  ) async {
    try {
      final response = await apiClient.getRequest('/vendors/$id');
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final rawData = apiResponse.data;
        final vendorData = rawData['vendor'] as Map<String, dynamic>?;
        final productsData = rawData['products'] as List<dynamic>?;

        final vendor = vendorData != null
            ? VendorProfile.fromMap(vendorData)
            : null;
        final products = productsData != null
            ? productsData
                  .map(
                    (e) => VendorInventory.fromMap(e as Map<String, dynamic>),
                  )
                  .toList()
            : <VendorInventory>[];

        return (vendor, products);
      }
      return (null, <VendorInventory>[]);
    } on Exception {
      return (null, <VendorInventory>[]);
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
