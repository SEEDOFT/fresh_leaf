import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class WishlistService extends GetxService {
  WishlistService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<PaginatedResponse<VendorInventory>> getWishlist({int page = 1}) async {
    final token = _apiClient.storageService.token;
    if (token == null || token.isEmpty) {
      return PaginatedResponse.empty();
    }
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.wishlist,
        queryParameters: {'page': page},
      );

      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        (map) {
          final inventory = map['vendor_inventory'] as Map<String, dynamic>;
          return VendorInventory.fromMap(inventory);
        },
      );

      if (apiResponse.isSuccess) {
        return apiResponse.data;
      }
      return PaginatedResponse.empty();
    } on Exception {
      return PaginatedResponse.empty();
    }
  }

  Future<bool> toggleWishlist(int vendorInventoryId) async {
    final token = _apiClient.storageService.token;
    if (token == null || token.isEmpty) {
      return false;
    }
    try {
      final response = await _apiClient.postRequest(
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
