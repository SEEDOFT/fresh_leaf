import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  CartService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<CartItem>> getCart() async {
    try {
      final response = await apiClient.getRequest(ApiEndpoints.cart);
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess && apiResponse.data['carts'] != null) {
        final dataList = apiResponse.data['carts'] as List<dynamic>;
        return dataList
            .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<bool> addToCart(int vendorInventoryId, double quantity) async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.cart,
        data: {
          'vendor_inventory_id': vendorInventoryId,
          'quantity': quantity,
        },
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }

  Future<bool> updateCartItem(int cartItemId, double quantity) async {
    try {
      final response = await apiClient.putRequest(
        ApiEndpoints.cartById.replaceFirst('{id}', cartItemId.toString()),
        data: {
          'quantity': quantity,
        },
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeCartItem(int cartItemId) async {
    try {
      final response = await apiClient.deleteRequest(
        ApiEndpoints.cartById.replaceFirst('{id}', cartItemId.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }

  Future<bool> checkout(
    int addressId,
    int paymentMethodId,
    int orderTypeId, {
    String? notes,
  }) async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.cartCheckout,
        data: {
          'address_id': addressId,
          'payment_method_id': paymentMethodId,
          'order_type_id': orderTypeId,
          'notes': ?notes,
        },
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }
}
