import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  group('ProductService', () {
    late MockApiClient mockClient;

    setUp(() {
      mockClient = MockApiClient();
    });

    group('getProducts', () {
      test('returns paginated products on success', () async {
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
                    'price': '10.00',
                    'stock_quantity': '5.00',
                    'price_display': <String, dynamic>{
                      'USD': '10.00',
                      'KHR': '41000.00',
                    },
                    'discounted_price_display': <String, dynamic>{},
                  },
                ],
                'current_page': 1,
              },
            },
          ),
        );

        final service = ProductService(apiClient: mockClient);
        final result = await service.getProducts();

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
                'message': 'Bad Request',
              },
            },
          ),
        );

        final service = ProductService(apiClient: mockClient);
        final result = await service.getProducts();

        expect(result.items, isEmpty);
      });

      test('returns empty on exception', () async {
        when(mockClient.getRequest(any, queryParameters: anyNamed('queryParameters'))).thenThrow(Exception('Network error'));

        final service = ProductService(apiClient: mockClient);
        final result = await service.getProducts();

        expect(result.items, isEmpty);
      });
    });

    group('getProduct', () {
      test('returns VendorInventory on success', () async {
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
                'id': 42,
                'price': '15.00',
                'stock_quantity': '10.00',
                'price_display': <String, dynamic>{
                  'USD': '15.00',
                  'KHR': '61500.00',
                },
                'discounted_price_display': <String, dynamic>{},
              },
            },
          ),
        );

        final service = ProductService(apiClient: mockClient);
        final result = await service.getProduct(42);

        expect(result, isNotNull);
        expect(result!.id, 42);
        expect(result.price, 15.0);
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

        final service = ProductService(apiClient: mockClient);
        final result = await service.getProduct(99);

        expect(result, isNull);
      });

      test('returns null on exception', () async {
        when(mockClient.getRequest(any)).thenThrow(Exception('Timeout'));

        final service = ProductService(apiClient: mockClient);
        final result = await service.getProduct(1);

        expect(result, isNull);
      });
    });

    group('getVendorProfile', () {
      test('returns vendor and products on success', () async {
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
                'vendor': <String, dynamic>{
                  'id': 1,
                  'name': 'Green Farm',
                  'email': 'green@farm.test',
                },
                'products': <dynamic>[
                  <String, dynamic>{
                    'id': 10,
                    'price': '5.00',
                    'stock_quantity': '3.00',
                    'price_display': <String, dynamic>{
                      'USD': '5.00',
                      'KHR': '20500.00',
                    },
                    'discounted_price_display': <String, dynamic>{},
                  },
                ],
              },
            },
          ),
        );

        final service = ProductService(apiClient: mockClient);
        final (vendor, products) = await service.getVendorProfile(1);

        expect(vendor, isNotNull);
        expect(vendor!.name, 'Green Farm');
        expect(products.length, 1);
        expect(products.first.id, 10);
      });

      test('returns null vendor when vendor key missing', () async {
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

        final service = ProductService(apiClient: mockClient);
        final (vendor, products) = await service.getVendorProfile(1);

        expect(vendor, isNull);
        expect(products, isEmpty);
      });
    });

    group('createProduct', () {
      test('returns true on success', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '201',
                'success': true,
                'message': 'Created',
              },
            },
          ),
        );

        final service = ProductService(apiClient: mockClient);
        final result = await service.createProduct(<String, dynamic>{
          'name': 'New Product',
        });

        expect(result, isTrue);
      });

      test('returns false on API failure', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '422',
                'success': false,
                'message': 'Validation error',
              },
            },
          ),
        );

        final service = ProductService(apiClient: mockClient);
        final result = await service.createProduct(<String, dynamic>{});

        expect(result, isFalse);
      });

      test('returns false on exception', () async {
        when(mockClient.postRequest(any, data: anyNamed('data')))
            .thenThrow(Exception('Connection failed'));

        final service = ProductService(apiClient: mockClient);
        final result = await service.createProduct(<String, dynamic>{});

        expect(result, isFalse);
      });
    });
  });
}
