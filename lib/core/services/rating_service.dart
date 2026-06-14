import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory_rating.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class RatingService extends GetxService {
  RatingService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<
    ({
      double averageRating,
      int ratingsCount,
      PaginatedResponse<VendorInventoryRating> ratings,
    })
  >
  getRatings(int vendorInventoryId, {int page = 1}) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.ratingByVendorInventory.replaceFirst(
          '{id}',
          vendorInventoryId.toString(),
        ),
        queryParameters: {'page': page},
      );

      final apiResponse = ApiResponse.parseMap(response.data);
      if (!apiResponse.isSuccess) {
        return (
          averageRating: 0.0,
          ratingsCount: 0,
          ratings: PaginatedResponse<VendorInventoryRating>.empty(),
        );
      }

      final data = apiResponse.data;
      final averageRating = (data['average_rating'] as num?)?.toDouble() ?? 0.0;
      final ratingsCount = data['ratings_count'] as int? ?? 0;

      final ratingsData = data['ratings'];
      final ratingsPaginated = PaginatedResponse<VendorInventoryRating>.fromMap(
        ratingsData,
        VendorInventoryRating.fromMap,
      );

      return (
        averageRating: averageRating,
        ratingsCount: ratingsCount,
        ratings: ratingsPaginated,
      );
    } on Exception {
      return (
        averageRating: 0.0,
        ratingsCount: 0,
        ratings: PaginatedResponse<VendorInventoryRating>.empty(),
      );
    }
  }

  Future<bool> submitRating({
    required int orderItemId,
    required int rating,
    String? review,
  }) async {
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.ratingStore,
        data: {
          'order_item_id': orderItemId,
          'rating': rating,
          if (review != null && review.isNotEmpty) 'review': review,
        },
      );
      return ApiResponse.parseMap(response.data).isSuccess;
    } on Exception {
      return false;
    }
  }
}
