import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'order_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  group('OrderService', () {
    late MockApiClient mockClient;

    setUp(() {
      mockClient = MockApiClient();
    });

    group('getOrders', () {
      test('returns paginated orders on success', () async {
        when(mockClient.getRequest(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
              'data': <String, dynamic>{
                'data': <dynamic>[
                  <String, dynamic>{
                    'id': 1,
                    'order_number': 'FL-001',
                    'total_amount': '10.00',
                    'subtotal': '10.00',
                    'discount_amount': '0.00',
                    'delivery_fee': '0.00',
                    'tax_amount': '0.00',
                    'total_amount_display': <String, dynamic>{
                      'USD': '10.00',
                      'KHR': '41000.00',
                    },
                    'items': <dynamic>[],
                  },
                ],
                'current_page': 1,
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.getOrders();

        expect(result.items.length, 1);
        expect(result.items.first.id, 1);
        expect(result.currentPage, 1);
      });

      test('returns empty on API failure', () async {
        when(mockClient.getRequest(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '400',
                'success': false,
                'message': 'Error',
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.getOrders();

        expect(result.items, isEmpty);
      });

      test('returns empty on exception', () async {
        when(mockClient.getRequest(any, queryParameters: anyNamed('queryParameters'))).thenThrow(Exception('Network error'));

        final service = OrderService(apiClient: mockClient);
        final result = await service.getOrders();

        expect(result.items, isEmpty);
      });
    });

    group('getOrder', () {
      test('returns Order on success with data wrapper', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
              'data': <String, dynamic>{
                'data': <String, dynamic>{
                  'id': 42,
                  'order_number': 'FL-042',
                  'total_amount': '25.00',
                  'subtotal': '25.00',
                  'discount_amount': '0.00',
                  'delivery_fee': '0.00',
                  'tax_amount': '0.00',
                  'total_amount_display': <String, dynamic>{
                    'USD': '25.00',
                    'KHR': '102500.00',
                  },
                  'items': <dynamic>[],
                },
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.getOrder(42);

        expect(result, isNotNull);
        expect(result!.id, 42);
        expect(result.orderNumber, 'FL-042');
      });

      test('returns Order on success without data wrapper', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
              'data': <String, dynamic>{
                'id': 1,
                'order_number': 'FL-001',
                'total_amount': '10.00',
                'subtotal': '10.00',
                'discount_amount': '0.00',
                'delivery_fee': '0.00',
                'tax_amount': '0.00',
                'total_amount_display': <String, dynamic>{
                  'USD': '10.00',
                  'KHR': '41000.00',
                },
                'items': <dynamic>[],
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.getOrder(1);

        expect(result, isNotNull);
        expect(result!.id, 1);
      });

      test('returns null on API failure', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '404',
                'success': false,
                'message': 'Not found',
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.getOrder(99);

        expect(result, isNull);
      });
    });

    group('cancelOrder', () {
      test('returns true on success', () async {
        when(mockClient.postRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.cancelOrder(1);

        expect(result, isTrue);
      });

      test('returns false on exception', () async {
        when(mockClient.postRequest(any)).thenThrow(Exception('Failed'));

        final service = OrderService(apiClient: mockClient);
        final result = await service.cancelOrder(1);

        expect(result, isFalse);
      });
    });

    group('confirmReceipt', () {
      test('returns true on success', () async {
        when(mockClient.postRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.confirmReceipt(1);

        expect(result, isTrue);
      });
    });

    group('payWithWallet', () {
      test('returns true on success', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.payWithWallet(1, 1);

        expect(result, isTrue);
      });
    });

    group('batchPayWithWallet', () {
      test('returns true on success', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
              'data': <dynamic>[],
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final result = await service.batchPayWithWallet([1, 2], 1);

        expect(result, isTrue);
      });
    });

    group('getInvoiceUrl', () {
      test('returns url on success', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
              'data': <String, dynamic>{'url': 'https://example.test/invoice/1'},
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final url = await service.getInvoiceUrl(1);

        expect(url, 'https://example.test/invoice/1');
      });

      test('returns null when url key is missing', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '200',
                'success': true,
                'message': 'OK',
              },
              'data': <String, dynamic>{},
            },
          ),
        );

        final service = OrderService(apiClient: mockClient);
        final url = await service.getInvoiceUrl(1);

        expect(url, isNull);
      });
    });
  });
}
