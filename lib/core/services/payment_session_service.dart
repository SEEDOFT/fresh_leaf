import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/models/payment_session.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class PaymentSessionService extends GetxService {
  PaymentSessionService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<PaymentSession> createTopUpSession({
    required double amount,
    required String currency,
    required String paymentMethodTypeCode,
    int? paymentMethodId,
  }) async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.walletTopUpSessions,
      data: <String, dynamic>{
        'amount': amount,
        'currency': currency,
        'payment_method_type_code': paymentMethodTypeCode,
        if (paymentMethodId != null && paymentMethodId > 0)
          'payment_method_id': paymentMethodId,
      },
    );
    final apiResponse = ApiResponse.parseMap(response.data);
    return PaymentSession.fromMap(apiResponse.data);
  }

  Future<PaymentSession> createCheckoutSession({
    required double amount,
    required String paymentMethodTypeCode,
    int? paymentMethodId,
    List<Map<String, dynamic>>? items,
  }) async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.checkoutSessions,
      data: <String, dynamic>{
        'amount': amount,
        'payment_method_type_code': paymentMethodTypeCode,
        if (paymentMethodId != null && paymentMethodId > 0)
          'payment_method_id': paymentMethodId,
        'items': ?items,
      },
    );
    final apiResponse = ApiResponse.parseMap(response.data);
    return PaymentSession.fromMap(apiResponse.data);
  }

  Future<PaymentSession> getSessionStatus(String sessionId) async {
    final path = ApiEndpoints.paymentSession.replaceAll(
      '{id}',
      sessionId,
    );
    final response = await _apiClient.getRequest(path);
    final apiResponse = ApiResponse.parseMap(response.data);
    return PaymentSession.fromMap(apiResponse.data);
  }
}
