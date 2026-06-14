import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/app_notification.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'notification_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>(), MockSpec<StorageService>()])
void main() {
  group('NotificationService', () {
    late MockApiClient mockClient;

    late MockStorageService mockStorage;

    setUp(() {
      mockStorage = MockStorageService();
      when(mockStorage.token).thenReturn('test-token');
      when(mockStorage.onStart).thenReturn(InternalFinalCallback<void>(callback: () {}));
      mockClient = MockApiClient();
      Get.put<StorageService>(mockStorage);
    });

    tearDown(() {
      Get.reset();
    });

    group('getNotifications', () {
      test('returns parsed notifications on success', () async {
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
                'data': <dynamic>[
                  <String, dynamic>{
                    'id': 1,
                    'title': 'Order Update',
                    'message': 'Your order has been shipped',
                    'is_read': false,
                    'created_at': '2025-01-01T00:00:00.000',
                  },
                  <String, dynamic>{
                    'id': 2,
                    'title': 'Welcome',
                    'message': 'Welcome to FreshLeaf',
                    'is_read': true,
                    'created_at': '2025-01-02T00:00:00.000',
                  },
                ],
                'current_page': 1,
              },
            },
          ),
        );

        final service = NotificationService(apiClient: mockClient);
        final result = await service.getNotifications();

        expect(result.items.length, 2);
        expect(result.items.first.id, 1);
        expect(result.items.first.title, 'Order Update');
        expect(service.notifications.length, 2);
        expect(service.unreadCount.value, 1);
      });

      test('returns empty on API failure', () async {
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

        final service = NotificationService(apiClient: mockClient);
        final result = await service.getNotifications();

        expect(result.items, isEmpty);
      });

      test('returns empty on exception', () async {
        when(
          mockClient.getRequest(
            any,
            queryParameters: anyNamed('queryParameters'),
          ),
        ).thenThrow(Exception('Network error'));

        final service = NotificationService(apiClient: mockClient);
        final result = await service.getNotifications();

        expect(result.items, isEmpty);
      });
    });

    group('markAsRead', () {
      test('calls API, decrements unreadCount on success', () async {
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

        final service = NotificationService(apiClient: mockClient);
        service.notifications.addAll([
          AppNotification(
            id: 1,
            title: 'Test',
            message: 'Test message',
            isRead: false,
          ),
        ]);
        service.unreadCount.value = 1;

        final result = await service.markAsRead(1);

        expect(result, isTrue);
        expect(service.unreadCount.value, 0);
        expect(service.notifications.first.isRead, isTrue);
      });

      test('returns false on API failure', () async {
        when(mockClient.postRequest(any)).thenAnswer(
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

        final service = NotificationService(apiClient: mockClient);
        final result = await service.markAsRead(1);

        expect(result, isFalse);
      });
    });

    group('markAllAsRead', () {
      test('calls API, resets unreadCount on success', () async {
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

        final service = NotificationService(apiClient: mockClient);
        service.notifications.addAll([
          AppNotification(
            id: 1,
            title: 'A',
            message: 'A message',
            isRead: false,
          ),
          AppNotification(
            id: 2,
            title: 'B',
            message: 'B message',
            isRead: true,
          ),
        ]);
        service.unreadCount.value = 1;

        final result = await service.markAllAsRead();

        expect(result, isTrue);
        expect(service.unreadCount.value, 0);
        expect(service.notifications.every((n) => n.isRead), isTrue);
      });
    });

    group('fetchUnreadChatCount', () {
      test('updates unreadChatCount on success', () async {
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
                'count': 5,
              },
            },
          ),
        );

        final service = NotificationService(apiClient: mockClient);
        await service.fetchUnreadChatCount();

        expect(service.unreadChatCount.value, 5);
      });
    });
  });
}
