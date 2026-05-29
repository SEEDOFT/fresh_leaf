import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/core/models/cart_snapshot.dart';
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  CartService({required this.apiClient});

  final ApiClient apiClient;

  Future<CartSnapshot> getCartSnapshot() async {
    try {
      final response = await apiClient.getRequest(ApiEndpoints.cart);
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess && apiResponse.data['carts'] != null) {
        final dataList = apiResponse.data['carts'] as List<dynamic>;
        final items = dataList
            .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
            .toList();
        return CartSnapshot(
          items: items,
          totalDisplay: MoneyDisplay.fromMap(apiResponse.data['total']),
        );
      }
      return CartSnapshot.empty;
    } on Exception {
      return CartSnapshot.empty;
    }
  }

  Future<List<CartItem>> getCart() async {
    final snapshot = await getCartSnapshot();
    return snapshot.items;
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

  Future<List<int>?> checkout(
    int addressId,
    int? paymentMethodId,
    int? paymentMethodTypeId,
    int orderTypeId, {
    String? notes,
  }) async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.cartCheckout,
        data: {
          'address_id': addressId,
          'payment_method_id': paymentMethodId,
          'payment_method_type_id': paymentMethodTypeId,
          'order_type_id': orderTypeId,
          'notes': notes != null && notes.isNotEmpty ? notes : null,
        },
      );
      final apiResponse = ApiResponse.parseList(response.data);
      if (apiResponse.isSuccess) {
        final ids = <int>[];
        for (final item in apiResponse.data) {
          if (item.containsKey('id')) {
            ids.add(item['id'] as int);
          }
        }
        if (ids.isNotEmpty) return ids;
      }
      return null;
    } on Exception {
      return null;
    }
  }
}
