import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/rating_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rating_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  group('RatingService', () {
    late MockApiClient mockClient;

    setUp(() {
      mockClient = MockApiClient();
    });

    group('getRatings', () {
      const vendorInventoryId = 42;

      test('returns parsed data on success', () async {
        when(
          mockClient.getRequest(
            any,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).thenAnswer(
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
                'average_rating': 4.5,
                'ratings_count': 10,
                'ratings': <String, dynamic>{
                  'data': <dynamic>[
                    <String, dynamic>{
                      'id': 1,
                      'user_id': 100,
                      'user_name': 'Alice',
                      'vendor_inventory_id': 42,
                      'rating': 5,
                      'review': 'Great!',
                      'created_at': '2025-01-01T00:00:00.000',
                    },
                  ],
                  'current_page': 1,
                },
              },
            },
          ),
        );

        final service = RatingService(apiClient: mockClient);
        final result = await service.getRatings(vendorInventoryId);

        expect(result.averageRating, 4.5);
        expect(result.ratingsCount, 10);
        expect(result.ratings.items.length, 1);
        expect(result.ratings.items.first.id, 1);
        expect(result.ratings.items.first.rating, 5);
      });

      test('returns defaults on API failure', () async {
        when(
          mockClient.getRequest(
            any,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).thenAnswer(
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

        final service = RatingService(apiClient: mockClient);
        final result = await service.getRatings(vendorInventoryId);

        expect(result.averageRating, 0.0);
        expect(result.ratingsCount, 0);
        expect(result.ratings.items, isEmpty);
      });

      test('returns defaults on DioException', () async {
        when(
          mockClient.getRequest(
            any,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).thenThrow(
          dio.DioException(
            requestOptions: dio.RequestOptions(path: ''),
            message: 'Connection timeout',
          ),
        );

        final service = RatingService(apiClient: mockClient);
        final result = await service.getRatings(vendorInventoryId);

        expect(result.averageRating, 0.0);
        expect(result.ratingsCount, 0);
        expect(result.ratings.items, isEmpty);
      });

      test('returns defaults on Exception', () async {
        when(
          mockClient.getRequest(
            any,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).thenThrow(Exception('Network error'));

        final service = RatingService(apiClient: mockClient);
        final result = await service.getRatings(vendorInventoryId);

        expect(result.averageRating, 0.0);
        expect(result.ratingsCount, 0);
        expect(result.ratings.items, isEmpty);
      });
    });

    group('submitRating', () {
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

        final service = RatingService(apiClient: mockClient);
        final result = await service.submitRating(
          orderItemId: 1,
          rating: 5,
          review: 'Excellent',
        );

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

        final service = RatingService(apiClient: mockClient);
        final result = await service.submitRating(orderItemId: 1, rating: 5);

        expect(result, isFalse);
      });

      test('returns false on Exception', () async {
        when(
          mockClient.postRequest(any, data: anyNamed('data')),
        ).thenThrow(Exception('Connection failed'));

        final service = RatingService(apiClient: mockClient);
        final result = await service.submitRating(
          orderItemId: 1,
          rating: 3,
          review: 'Okay',
        );

        expect(result, isFalse);
      });
    });
  });
}
