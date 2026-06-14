import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class OrderService extends GetxService {
  OrderService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Map<int, int>> getOrderCounts() async {
    try {
      final response = await _apiClient.getRequest(ApiEndpoints.orderCounts);
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess && response.statusCode == 200) {
        final data = apiResponse.data;
        final counts = <int, int>{};
        for (final entry in data.entries) {
          final key = int.tryParse(entry.key) ?? 0;
          final value = entry.value;
          if (value is num) {
            counts[key] = value.toInt();
          }
        }
        return counts;
      }
      return {};
    } on Exception {
      return {};
    }
  }

  Future<PaginatedResponse<Order>> getOrders({int page = 1}) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.orders,
        queryParameters: {'page': page},
      );
      final apiResponse = ApiResponse.parsePaginated(
        response.data,
        Order.fromMap,
      );

      if (apiResponse.isSuccess && response.statusCode == 200) {
        return apiResponse.data;
      }
      return PaginatedResponse.empty();
    } on Exception {
      return PaginatedResponse.empty();
    }
  }

  Future<Order?> getOrder(int id) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.orderById.replaceAll('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);

      if (apiResponse.isSuccess && response.statusCode == 200) {
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
      final response = await _apiClient.postRequest(
        ApiEndpoints.orderCancel.replaceAll('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess && response.statusCode == 200;
    } on Exception {
      return false;
    }
  }

  Future<bool> confirmReceipt(int id) async {
    try {
      final response = await _apiClient.postRequest(
        ApiEndpoints.orderConfirmReceipt.replaceAll('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess && response.statusCode == 200;
    } on Exception {
      return false;
    }
  }

  Future<bool> payWithWallet(int orderId, int walletId, String pin) async {
    try {
      final response = await _apiClient.postRequest(
        '${ApiEndpoints.orders}/$orderId/pay',
        data: {'wallet_id': walletId, 'pin': pin},
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      return apiResponse.isSuccess && response.statusCode == 200;
    } on Exception {
      return false;
    }
  }

  Future<bool> batchPayWithWallet(
    List<int> orderIds,
    int walletId,
    String pin,
  ) async {
    try {
      final response = await _apiClient.postRequest(
        '${ApiEndpoints.orders}/batch-pay',
        data: {
          'order_ids': orderIds,
          'wallet_id': walletId,
          'pin': pin,
        },
      );
      final apiResponse = ApiResponse.parseList(response.data);
      return apiResponse.isSuccess && response.statusCode == 200;
    } on Exception {
      return false;
    }
  }

  Future<String?> getInvoiceUrl(int id) async {
    try {
      final response = await _apiClient.getRequest(
        ApiEndpoints.orderInvoiceUrl.replaceAll('{id}', id.toString()),
      );
      final apiResponse = ApiResponse.parseMap(response.data);
      if (apiResponse.isSuccess && response.statusCode == 200) {
        return apiResponse.data['url'] as String?;
      }
      return null;
    } on Exception {
      return null;
    }
  }
}
