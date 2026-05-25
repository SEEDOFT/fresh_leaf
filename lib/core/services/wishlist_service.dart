import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class WishlistService extends GetxService {
  WishlistService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<VendorInventory>> getWishlist() async {
    final token = apiClient.storageService.token;
    if (token == null || token.isEmpty) {
      return [];
    }
    try {
      final response = await apiClient.getRequest(ApiEndpoints.wishlist);
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final rawData = apiResponse.data;
        final data = rawData['wishlists'] as List<dynamic>?;

        if (data == null) return [];

        return data.cast<Map<String, dynamic>>().map((item) {
          final inventory = item['vendor_inventory'] as Map<String, dynamic>;
          return VendorInventory.fromMap(inventory);
        }).toList();
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<bool> toggleWishlist(int vendorInventoryId) async {
    final token = apiClient.storageService.token;
    if (token == null || token.isEmpty) {
      return false;
    }
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.wishlistToggle,
        data: {'vendor_inventory_id': vendorInventoryId},
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }
}
