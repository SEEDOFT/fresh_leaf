import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ai_assistant_api_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
void main() {
  group('AiAssistantApiService', () {
    late MockApiClient mockClient;

    setUp(() {
      mockClient = MockApiClient();
    });

    group('createSession', () {
      test('returns extracted data map on success', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{
                'data': <String, dynamic>{'session_id': 'sess_001'},
              },
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final result = await service.createSession();

        expect(result['session_id'], 'sess_001');
      });

      test('returns raw data when no nested data key', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{'session_id': 'sess_002'},
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final result = await service.createSession();

        expect(result['session_id'], 'sess_002');
      });

      test('returns empty map on empty data', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{},
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final result = await service.createSession();

        expect(result, isEmpty);
      });
    });

    group('checkStatus', () {
      test('returns true when available is true', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{
                'data': <String, dynamic>{'available': true},
              },
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final result = await service.checkStatus();

        expect(result, isTrue);
      });

      test('returns false when available is false', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{
                'data': <String, dynamic>{'available': false},
              },
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final result = await service.checkStatus();

        expect(result, isFalse);
      });
    });

    group('sendMessage', () {
      test('returns AiChatSendMessageResult on success', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{
                'session_id': 'sess_001',
                'user_message_id': 'um_1',
                'ai_message_id': 'am_1',
                'status': 'queued',
              },
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final result = await service.sendMessage(
          sessionId: 'sess_001',
          prompt: 'Hello',
        );

        expect(result.sessionId, 'sess_001');
        expect(result.userMessageId, 'um_1');
        expect(result.assistantMessageId, 'am_1');
        expect(result.status, 'queued');
      });
    });

    group('fetchHistory', () {
      test('returns list of AiChatMessage from items array', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{
                'items': <dynamic>[
                  <String, dynamic>{
                    'text': 'Hello',
                    'role': 'user',
                    'message_id': 'm1',
                    'sequence': 1,
                  },
                  <String, dynamic>{
                    'text': 'Hi there',
                    'role': 'assistant',
                    'message_id': 'm2',
                    'sequence': 2,
                  },
                ],
              },
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final messages = await service.fetchHistory(sessionId: 'sess_001');

        expect(messages.length, 2);
        expect(messages.first.text, 'Hello');
        expect(messages.first.isUser, isTrue);
        expect(messages.last.isUser, isFalse);
      });

      test('falls back to content key when text is empty', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{
                'messages': <dynamic>[
                  <String, dynamic>{
                    'content': 'Fallback content',
                    'role': 'USER',
                    'id': 'm3',
                  },
                ],
              },
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final messages = await service.fetchHistory(sessionId: 'sess_001');

        expect(messages.length, 1);
        expect(messages.first.text, 'Fallback content');
        expect(messages.first.isUser, isTrue);
      });

      test('returns empty list when no items key', () async {
        when(mockClient.postRequest(any, data: anyNamed('data'))).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{},
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final messages = await service.fetchHistory(sessionId: 'sess_001');

        expect(messages, isEmpty);
      });
    });

    group('resolveUserId', () {
      test('returns user id from profile', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{
                'data': <String, dynamic>{'id': 'user_42'},
              },
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);
        final userId = await service.resolveUserId();

        expect(userId, 'user_42');
      });

      test('throws FormatException when id is missing', () async {
        when(mockClient.getRequest(any)).thenAnswer(
          (_) async => dio.Response<Map<String, dynamic>>(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 200,
            data: <String, dynamic>{
              'status': <String, dynamic>{'code': '200', 'success': true},
              'data': <String, dynamic>{'data': <String, dynamic>{}},
            },
          ),
        );

        final service = AiAssistantApiService(apiClient: mockClient);

        expect(
          () => service.resolveUserId(),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('parseError', () {
      test('returns parsed API error message for DioException', () {
        final service = AiAssistantApiService(apiClient: mockClient);
        final error = dio.DioException(
          requestOptions: dio.RequestOptions(path: ''),
          response: dio.Response(
            requestOptions: dio.RequestOptions(path: ''),
            statusCode: 400,
            data: <String, dynamic>{
              'status': <String, dynamic>{
                'code': '400',
                'message': 'Bad request',
              },
            },
          ),
        );

        final result = service.parseError(error, fallback: 'Fallback');
        expect(result, 'Bad request');
      });

      test('returns fallback for non-DioException', () {
        final service = AiAssistantApiService(apiClient: mockClient);
        final result = service.parseError(
          Exception('Some error'),
          fallback: 'Fallback message',
        );

        expect(result, 'Fallback message');
      });
    });
  });
}
