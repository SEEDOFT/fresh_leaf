import 'package:dio/dio.dart';
import 'package:fresh_leaf/core/constants/api_endpoints.dart';
import 'package:fresh_leaf/core/models/ai_chat_message.dart';
import 'package:fresh_leaf/core/models/ai_chat_send_message_result.dart';
import 'package:fresh_leaf/core/models/ai_chat_session.dart';
import 'package:fresh_leaf/core/models/api_response.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:get/get.dart';

class AiAssistantApiService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<AiChatSession> createSession() async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.aiChatSessions,
      data: <String, dynamic>{},
    );
    final apiResponse = ApiResponse.parseMap(response.data);
    final sessionMap = _extractDataMap(apiResponse.data);
    return AiChatSession.fromMap(sessionMap);
  }

  Future<AiChatSendMessageResult> sendMessage({
    required String sessionId,
    required String prompt,
  }) async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.aiChatMessages,
      data: <String, dynamic>{
        'session_id': sessionId,
        // Backward compatibility: current 
        // backend validation requires `message`.
        'message': prompt,
        // Keep `prompt` to match the new contract when backend supports it.
        'prompt': prompt,
      },
    );
    final apiResponse = ApiResponse.parseMap(response.data);
    return AiChatSendMessageResult.fromMap(apiResponse.data);
  }

  Future<List<AiChatMessage>> fetchHistory({required String sessionId}) async {
    final response = await _apiClient.postRequest(
      ApiEndpoints.aiChatHistory,
      data: <String, dynamic>{
        'session_id': sessionId,
      },
    );
    final apiResponse = ApiResponse.parseDynamic(response.data);
    final listData = _extractList(apiResponse.data);

    return listData.map((item) {
      final text = formatToString(item['text']).isNotEmpty
          ? formatToString(item['text'])
          : formatToString(item['content']);
      final role = formatToString(item['role']).toLowerCase();
      final status = formatToString(item['status'], defaultValue: 'done');
      return AiChatMessage(
        text: text,
        isUser: role == 'user',
        isStreaming: status == 'queued' || status == 'streaming',
        sessionId: sessionId,
        messageId: formatToString(item['message_id']).isNotEmpty
            ? formatToString(item['message_id'])
            : formatToString(item['id']),
        sequence: toInt(item['sequence']),
        status: status,
      );
    }).toList();
  }

  Future<String> resolveUserId() async {
    final response = await _apiClient.getRequest(ApiEndpoints.userProfile);
    final apiResponse = ApiResponse.parseMap(response.data);
    final profileData = _extractDataMap(apiResponse.data);
    final userId = formatToString(profileData['id']);
    if (userId.isEmpty) {
      throw const FormatException('Missing user id in /users/profile response');
    }
    return userId;
  }

  Map<String, dynamic> _extractDataMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    if (data is Map) {
      return data.map<String, dynamic>(
        (key, value) => MapEntry<String, dynamic>(key.toString(), value),
      );
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractList(dynamic data) {
    if (data is List) {
      return data.whereType<Map<dynamic, dynamic>>().map((item) {
        return item.map<String, dynamic>(
          (key, value) => MapEntry<String, dynamic>(key.toString(), value),
        );
      }).toList();
    }

    if (data is Map<String, dynamic>) {
      final nestedData = data['items'] ?? data['messages'] ?? data['data'];
      if (nestedData is List) {
        return nestedData.whereType<Map<dynamic, dynamic>>().map((item) {
          return item.map<String, dynamic>(
            (key, value) => MapEntry<String, dynamic>(key.toString(), value),
          );
        }).toList();
      }
    }

    return <Map<String, dynamic>>[];
  }

  String parseError(Object error, {required String fallback}) {
    if (error is DioException) {
      return parseApiErrorMessage(error, fallback: fallback);
    }
    return fallback;
  }
}
