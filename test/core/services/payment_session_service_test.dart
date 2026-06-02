import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'payment_session_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  group('PaymentSessionService', () {
    late MockApiClient mockClient;

    setUp(() {
      mockClient = MockApiClient();
    });

    group('createTopUpSession', () {
      test('returns PaymentSession on success', () async {
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
              'data': <String, dynamic>{
                'session_id': 'topup_sess_001',
                'status': <String, dynamic>{'id': 1},
              },
            },
          ),
        );

        final service = PaymentSessionService(apiClient: mockClient);
        final session = await service.createTopUpSession(
          amount: 10.0,
          currency: 'USD',
          paymentMethodTypeCode: 'aba',
        );

        expect(session.sessionId, 'topup_sess_001');
        expect(session.statusId, 1);
        expect(session.isPaid, isFalse);
      });

      test('includes payment_method_id when provided', () async {
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
              'data': <String, dynamic>{
                'session_id': 'sess_002',
                'status': <String, dynamic>{'id': 1},
              },
            },
          ),
        );

        final service = PaymentSessionService(apiClient: mockClient);
        await service.createTopUpSession(
          amount: 20.0,
          currency: 'KHR',
          paymentMethodTypeCode: 'card',
          paymentMethodId: 5,
        );

        final captured = verify(
          mockClient.postRequest(any, data: captureAnyNamed('data')),
        ).captured;
        expect((captured.first as Map)['payment_method_id'], 5);
      });

      test('omits payment_method_id when 0', () async {
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
              'data': <String, dynamic>{
                'session_id': 'sess_003',
                'status': <String, dynamic>{'id': 1},
              },
            },
          ),
        );

        final service = PaymentSessionService(apiClient: mockClient);
        await service.createTopUpSession(
          amount: 5.0,
          currency: 'USD',
          paymentMethodTypeCode: 'aba',
          paymentMethodId: 0,
        );

        final captured = verify(
          mockClient.postRequest(any, data: captureAnyNamed('data')),
        ).captured;
        expect(
          (captured.first as Map).containsKey('payment_method_id'),
          isFalse,
        );
      });
    });

    group('createCheckoutSession', () {
      test('returns PaymentSession on success', () async {
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
              'data': <String, dynamic>{
                'session_id': 'checkout_sess_001',
                'status': <String, dynamic>{'id': 1},
              },
            },
          ),
        );

        final service = PaymentSessionService(apiClient: mockClient);
        final session = await service.createCheckoutSession(
          amount: 15.50,
          paymentMethodTypeCode: 'credit_card',
        );

        expect(session.sessionId, 'checkout_sess_001');
      });
    });

    group('getSessionStatus', () {
      test('returns PaymentSession on success', () async {
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
                'session_id': 'existing_sess',
                'status': <String, dynamic>{'id': 2},
              },
            },
          ),
        );

        final service = PaymentSessionService(apiClient: mockClient);
        final session = await service.getSessionStatus('existing_sess');

        expect(session.sessionId, 'existing_sess');
        expect(session.isPaid, isTrue);
      });
    });
  });
}
