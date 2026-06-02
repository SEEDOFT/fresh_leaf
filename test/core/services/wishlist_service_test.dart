import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wishlist_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>(), MockSpec<StorageService>()])
void main() {
  group('WishlistService', () {
    late MockApiClient mockClient;
    late MockStorageService mockStorage;

    setUp(() {
      mockStorage = MockStorageService();
      mockClient = MockApiClient();
      when(mockStorage.token).thenReturn('test-token');
      when(mockClient.storageService).thenReturn(mockStorage);
    });

    group('getWishlist', () {
      test('returns paginated items on success', () async {
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
                    'vendor_inventory': <String, dynamic>{
                      'id': 1,
                      'price': '10.00',
                      'stock_quantity': '5.00',
                      'price_display': <String, dynamic>{
                        'USD': '10.00',
                        'KHR': '41000.00',
                      },
                      'discounted_price_display': <String, dynamic>{},
                    },
                  },
                ],
                'current_page': 1,
              },
            },
          ),
        );

        final service = WishlistService(apiClient: mockClient);
        final result = await service.getWishlist();

        expect(result.items.length, 1);
        expect(result.items.first.id, 1);
      });

      test('returns empty on exception', () async {
        when(mockClient.getRequest(any, queryParameters: anyNamed('queryParameters'))).thenThrow(Exception('Error'));

        final service = WishlistService(apiClient: mockClient);
        final result = await service.getWishlist();

        expect(result.items, isEmpty);
      });
    });

    group('toggleWishlist', () {
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

        final service = WishlistService(apiClient: mockClient);
        final result = await service.toggleWishlist(1);

        expect(result, isTrue);
      });

      test('returns false on exception', () async {
        when(mockClient.postRequest(any, data: anyNamed('data')))
            .thenThrow(Exception('Failed'));

        final service = WishlistService(apiClient: mockClient);
        final result = await service.toggleWishlist(1);

        expect(result, isFalse);
      });
    });
  });
}
