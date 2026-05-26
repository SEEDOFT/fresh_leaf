import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class OrderService extends GetxService {
  OrderService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<Order>> getOrders() async {
    try {
      final response = await apiClient.getRequest(
        ApiEndpoints.orders,
      );
      final apiResponse = ApiResponse.parseList(response.data);

      if (apiResponse.isSuccess) {
        return apiResponse.data.map(Order.fromMap).toList();
      }
      return [];
    } on Exception {
      return [];
    }
  }

  Future<Order?> getOrder(int id) async {
    try {
      final response = await apiClient.getRequest(
        ApiEndpoints.orderById.replaceAll('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess) {
        final data = apiResponse.data['data'] ?? apiResponse.data;
        if (data is Map<String, dynamic> && data.isNotEmpty) {
          return Order.fromMap(data);
        }
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Future<bool> cancelOrder(int id) async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.orderCancel.replaceAll('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }

  Future<bool> confirmReceipt(int id) async {
    try {
      final response = await apiClient.postRequest(
        ApiEndpoints.orderConfirmReceipt.replaceAll('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }

  Future<bool> payWithWallet(int orderId, int walletId) async {
    try {
      final response = await apiClient.postRequest(
        '${ApiEndpoints.orders}/$orderId/pay',
        data: {'wallet_id': walletId},
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess;
    } on Exception {
      return false;
    }
  }
}
