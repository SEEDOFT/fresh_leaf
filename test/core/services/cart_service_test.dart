import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  group('CartService', () {
    late MockApiClient mockClient;

    setUp(() {
      mockClient = MockApiClient();
    });

    group('getCartSnapshot', () {
      test('returns snapshot with items on success', () async {
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
                'carts': <dynamic>[
                  <String, dynamic>{
                    'id': 1,
                    'vendor_inventory_id': 10,
                    'quantity': '2.00',
                    'subtotal': '5.40',
                    'discounted_unit_price_display': <String, dynamic>{
                      'USD': '2.70',
                      'KHR': '11070.00',
                    },
                    'subtotal_display': <String, dynamic>{
                      'USD': '5.40',
                      'KHR': '22140.00',
                    },
                  },
                ],
                'total': <String, dynamic>{
                  'USD': '5.40',
                  'KHR': '22140.00',
                },
              },
            },
          ),
        );

        final service = CartService(apiClient: mockClient);
        final snapshot = await service.getCartSnapshot();

        expect(snapshot.items.length, 1);
        expect(snapshot.items.first.id, 1);
        expect(snapshot.totalDisplay.usdText, r'$5.40');
        expect(snapshot.totalDisplay.khrText, '22,140 KHR');
      });

      test('returns empty snapshot when carts key is null', () async {
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

        final service = CartService(apiClient: mockClient);
        final snapshot = await service.getCartSnapshot();

        expect(snapshot.items, isEmpty);
      });

      test('returns empty snapshot on API failure', () async {
        when(mockClient.getRequest(any)).thenAnswer(
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

        final service = CartService(apiClient: mockClient);
        final snapshot = await service.getCartSnapshot();

        expect(snapshot.items, isEmpty);
      });

      test('returns empty snapshot on exception', () async {
        when(mockClient.getRequest(any)).thenThrow(Exception('Network error'));

        final service = CartService(apiClient: mockClient);
        final snapshot = await service.getCartSnapshot();

        expect(snapshot.items, isEmpty);
      });
    });

    group('getCart', () {
      test('returns items list from snapshot', () async {
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
                'carts': <dynamic>[
                  <String, dynamic>{
                    'id': 1,
                    'vendor_inventory_id': 10,
                    'quantity': '1.00',
                    'subtotal': '3.00',
                    'discounted_unit_price_display': <String, dynamic>{
                      'USD': '3.00',
                      'KHR': '12300.00',
                    },
                    'subtotal_display': <String, dynamic>{
                      'USD': '3.00',
                      'KHR': '12300.00',
                    },
                  },
                ],
                'total': <String, dynamic>{
                  'USD': '3.00',
                  'KHR': '12300.00',
                },
              },
            },
          ),
        );

        final service = CartService(apiClient: mockClient);
        final items = await service.getCart();

        expect(items.length, 1);
      });
    });

    group('addToCart', () {
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

        final service = CartService(apiClient: mockClient);
        final result = await service.addToCart(10, 2.0);

        expect(result, isTrue);
      });

      test('returns false on exception', () async {
        when(
          mockClient.postRequest(any, data: anyNamed('data')),
        ).thenThrow(Exception('Failed'));

        final service = CartService(apiClient: mockClient);
        final result = await service.addToCart(1, 1.0);

        expect(result, isFalse);
      });
    });

    group('updateCartItem', () {
      test('returns true on success', () async {
        when(mockClient.putRequest(any, data: anyNamed('data'))).thenAnswer(
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

        final service = CartService(apiClient: mockClient);
        final result = await service.updateCartItem(5, 3.0);

        expect(result, isTrue);
      });
    });

    group('removeCartItem', () {
      test('returns true on success', () async {
        when(mockClient.deleteRequest(any)).thenAnswer(
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

        final service = CartService(apiClient: mockClient);
        final result = await service.removeCartItem(5);

        expect(result, isTrue);
      });
    });

    group('checkout', () {
      test('returns list of order IDs on success', () async {
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
              'data': <dynamic>[
                <String, dynamic>{'id': 101},
                <String, dynamic>{'id': 102},
              ],
            },
          ),
        );

        final service = CartService(apiClient: mockClient);
        final result = await service.checkout(1, null, null, 1);

        expect(result, [101, 102]);
      });

      test('returns null when response has no ids', () async {
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
              'data': <dynamic>[<String, dynamic>{}],
            },
          ),
        );

        final service = CartService(apiClient: mockClient);
        final result = await service.checkout(1, null, null, 1);

        expect(result, isNull);
      });

      test('returns null on API failure', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
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

        final service = CartService(apiClient: mockClient);
        final result = await service.checkout(1, null, null, 1);

        expect(result, isNull);
      });
    });
  });
}
