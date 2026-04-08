import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fresh_leaf/core/config/app_config.dart';
import 'package:fresh_leaf/core/models/ai_chat_realtime_event.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AiAssistantRealtimeService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final StreamController<AiChatRealtimeEvent> _eventController =
      StreamController<AiChatRealtimeEvent>.broadcast();
  final Dio _dio = Dio();

  WebSocketChannel? _socketChannel;
  StreamSubscription<dynamic>? _socketSubscription;
  Completer<void>? _connectionCompleter;
  Completer<void>? _subscriptionCompleter;

  String _socketId = '';
  String _activeChannel = '';
  String _pendingChannel = '';
  bool _isConnected = false;

  Stream<AiChatRealtimeEvent> get events => _eventController.stream;

  Future<void> connect() async {
    if (_isConnected) {
      return;
    }
    if (_connectionCompleter != null) {
      await _connectionCompleter!.future;
      return;
    }

    if (AppConfig.reverbWebSocketHost.isEmpty) {
      throw const FormatException('Missing REVERB_WS_HOST configuration');
    }
    if (AppConfig.reverbAppKey.isEmpty) {
      throw const FormatException('Missing REVERB_APP_KEY configuration');
    }

    _connectionCompleter = Completer<void>();

    final channel = WebSocketChannel.connect(_buildSocketUri());
    _socketChannel = channel;
    _socketSubscription = channel.stream.listen(
      _handleSocketMessage,
      onError: _handleSocketError,
      onDone: _handleSocketDone,
      cancelOnError: false,
    );

    try {
      await _connectionCompleter!.future.timeout(
        const Duration(seconds: 15),
      );
    } on TimeoutException {
      throw TimeoutException('Realtime socket connect timeout');
    } finally {
      _connectionCompleter = null;
    }
  }

  Future<void> disconnect() async {
    if (_activeChannel.isNotEmpty) {
      _sendRaw(
        <String, dynamic>{
          'event': 'pusher:unsubscribe',
          'data': <String, dynamic>{'channel': _activeChannel},
        },
      );
      _activeChannel = '';
    }

    await _socketSubscription?.cancel();
    _socketSubscription = null;
    await _socketChannel?.sink.close();
    _socketChannel = null;

    _socketId = '';
    _activeChannel = '';
    _pendingChannel = '';
    _isConnected = false;
  }

  Future<void> subscribeToSessionChannel({
    required String userId,
    required String sessionId,
  }) async {
    await connect();

    final channelName = 'private-ai-chat.$userId.$sessionId';
    if (_activeChannel == channelName && _isConnected) {
      return;
    }

    if (_activeChannel.isNotEmpty && _activeChannel != channelName) {
      _sendRaw(
        <String, dynamic>{
          'event': 'pusher:unsubscribe',
          'data': <String, dynamic>{'channel': _activeChannel},
        },
      );
      _activeChannel = '';
    }

    if (_socketId.isEmpty) {
      throw const FormatException('Missing socket id for channel auth');
    }

    final authPayload = await _authorizePrivateChannel(
      channelName: channelName,
      socketId: _socketId,
    );
    final authSignature = _toString(authPayload['auth']);
    if (authSignature.isEmpty) {
      throw const FormatException('Invalid auth response from backend');
    }

    final subscriptionData = <String, dynamic>{
      'channel': channelName,
      'auth': authSignature,
    };

    final channelData = authPayload['channel_data'];
    if (channelData != null) {
      subscriptionData['channel_data'] = channelData;
    }

    _pendingChannel = channelName;

    _subscriptionCompleter = Completer<void>();
    _sendRaw(
      <String, dynamic>{
        'event': 'pusher:subscribe',
        'data': subscriptionData,
      },
    );

    try {
      await _subscriptionCompleter!.future.timeout(
        const Duration(seconds: 10),
      );
      _activeChannel = channelName;
    } on TimeoutException {
      throw TimeoutException('Realtime channel subscribe timeout');
    } finally {
      _subscriptionCompleter = null;
    }
  }

  Future<Map<String, dynamic>> _authorizePrivateChannel({
    required String channelName,
    required String socketId,
  }) async {
    final token = _storageService.token;
    if (token == null || token.isEmpty) {
      throw const FormatException('Missing access token for Reverb auth');
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        AppConfig.reverbAuthEndpoint,
        data: <String, dynamic>{
          'socket_id': socketId,
          'channel_name': channelName,
        },
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;
      if (data == null || data.isEmpty) {
        throw const FormatException('Empty Reverb auth response');
      }

      return data;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final responseBody = error.response?.data;
      final responseText = responseBody == null ? '' : jsonEncode(responseBody);
      final message = responseText.isEmpty
          ? 'auth failed (${statusCode ?? '-'})'
          : 'auth failed (${statusCode ?? '-'}): $responseText';
      throw FormatException(message);
    }
  }

  void _handleSocketMessage(dynamic payload) {
    final message = _decodeMap(payload);
    if (message.isEmpty) {
      return;
    }

    final eventName = _toString(message['event']);
    if (eventName.isEmpty) {
      return;
    }

    if (eventName == 'pusher:connection_established') {
      _onConnectionEstablished(message['data']);
      return;
    }

    if (eventName == 'pusher:error') {
      _onPusherError(message['data']);
      return;
    }

    if (eventName == 'pusher:ping') {
      _sendRaw(
        <String, dynamic>{
          'event': 'pusher:pong',
          'data': '{}',
        },
      );
      return;
    }

    if (eventName == 'pusher_internal:subscription_succeeded' ||
        eventName == 'pusher:subscription_succeeded') {
      _onSubscriptionSucceeded(message);
      return;
    }

    if (_pendingChannel.isNotEmpty) {
      final channelName = _toString(message['channel']);
      if (channelName == _pendingChannel &&
          eventName == 'pusher_internal:subscription_error') {
        const errorMessage = 'Realtime subscription failed';
        _completeSubscriptionError(const FormatException(errorMessage));
        _emitFailureEvent(errorMessage);
        return;
      }
    }

    _onApplicationEvent(eventName: eventName, data: message['data']);
  }

  void _onConnectionEstablished(dynamic data) {
    final connectionData = _decodeMap(data);
    final socketId = _toString(connectionData['socket_id']);
    if (socketId.isEmpty) {
      return;
    }

    _socketId = socketId;
    _isConnected = true;
    _completeConnectionSuccess();
  }

  void _onPusherError(dynamic data) {
    final errorData = _decodeMap(data);
    final errorText = _toString(errorData['message']).isEmpty
        ? 'Realtime connection error'
        : _toString(errorData['message']);
    _completeConnectionError(FormatException(errorText));
    _completeSubscriptionError(FormatException(errorText));
    _emitFailureEvent(errorText);
  }

  void _onSubscriptionSucceeded(Map<String, dynamic> message) {
    final channelName = _toString(message['channel']);
    if (_pendingChannel.isNotEmpty && channelName != _pendingChannel) {
      return;
    }

    if (_pendingChannel.isNotEmpty) {
      _activeChannel = _pendingChannel;
    }
    _pendingChannel = '';
    _completeSubscriptionSuccess();
  }

  void _onApplicationEvent({
    required String eventName,
    required dynamic data,
  }) {
    final resolvedEventType = _resolveEventType(eventName);
    if (resolvedEventType == null) {
      return;
    }

    final payload = _decodeMap(data);
    if (payload.isEmpty) {
      return;
    }

    final realtimeEvent = AiChatRealtimeEvent.fromPayload(
      eventType: resolvedEventType,
      payload: payload,
    );

    if (!_eventController.isClosed) {
      _eventController.add(realtimeEvent);
    }
  }

  void _handleSocketError(Object error) {
    _isConnected = false;
    _socketId = '';
    _activeChannel = '';
    _pendingChannel = '';
    final message = error.toString();
    _completeConnectionError(error);
    _completeSubscriptionError(error);
    _emitFailureEvent(message);
  }

  void _handleSocketDone() {
    _isConnected = false;
    _socketId = '';
    _activeChannel = '';
    _pendingChannel = '';
    _completeConnectionError(
      const FormatException('Realtime connection closed'),
    );
  }

  void _sendRaw(Map<String, dynamic> payload) {
    final channel = _socketChannel;
    if (channel == null) {
      return;
    }
    channel.sink.add(jsonEncode(payload));
  }

  Uri _buildSocketUri() {
    final isSecure = AppConfig.reverbWebSocketScheme.toLowerCase() == 'wss';
    return Uri(
      scheme: isSecure ? 'wss' : 'ws',
      host: AppConfig.reverbWebSocketHost,
      port: AppConfig.reverbWebSocketPort,
      path: '/app/${AppConfig.reverbAppKey}',
      queryParameters: <String, String>{
        'protocol': '7',
        'client': 'flutter',
        'version': '1.0',
        'flash': 'false',
      },
    );
  }

  Map<String, dynamic> _decodeMap(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (payload is Map) {
      return payload.map<String, dynamic>(
        (key, value) => MapEntry<String, dynamic>(key.toString(), value),
      );
    }

    if (payload is String && payload.isNotEmpty) {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map<String, dynamic>(
          (key, value) => MapEntry<String, dynamic>(key.toString(), value),
        );
      }
    }

    return <String, dynamic>{};
  }

  String _toString(dynamic value) {
    if (value is String) {
      return value.trim();
    }
    return value?.toString().trim() ?? '';
  }

  void _completeConnectionSuccess() {
    final completer = _connectionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  void _completeConnectionError(Object error) {
    final completer = _connectionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error);
    }
  }

  void _completeSubscriptionSuccess() {
    final completer = _subscriptionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  void _completeSubscriptionError(Object error) {
    final completer = _subscriptionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error);
    }
  }

  void _emitFailureEvent(String message) {
    if (_eventController.isClosed) {
      return;
    }

    _eventController.add(
      AiChatRealtimeEvent(
        eventType: AiChatEventType.messageFailed,
        sessionId: '',
        messageId: '',
        role: 'assistant',
        timestamp: DateTime.now().toIso8601String(),
        sequence: 0,
        textChunk: message,
        fullText: message,
      ),
    );
  }

  String? _resolveEventType(String eventName) {
    final normalized = eventName.toLowerCase();
    if (_matchesEventType(
      normalized: normalized,
      expected: AiChatEventType.messageStarted,
      aliases: const <String>['aimessagestarted', 'ai.message.started'],
    )) {
      return AiChatEventType.messageStarted;
    }
    if (_matchesEventType(
      normalized: normalized,
      expected: AiChatEventType.messageChunk,
      aliases: const <String>['aimessagechunk', 'ai.message.chunk'],
    )) {
      return AiChatEventType.messageChunk;
    }
    if (_matchesEventType(
      normalized: normalized,
      expected: AiChatEventType.messageCompleted,
      aliases: const <String>['aimessagecompleted', 'ai.message.completed'],
    )) {
      return AiChatEventType.messageCompleted;
    }
    if (_matchesEventType(
      normalized: normalized,
      expected: AiChatEventType.messageFailed,
      aliases: const <String>['aimessagefailed', 'ai.message.failed'],
    )) {
      return AiChatEventType.messageFailed;
    }
    return null;
  }

  bool _matchesEventType({
    required String normalized,
    required String expected,
    required List<String> aliases,
  }) {
    final expectedLower = expected.toLowerCase();
    if (normalized == expectedLower || normalized.endsWith(expectedLower)) {
      return true;
    }
    for (final alias in aliases) {
      if (normalized == alias || normalized.endsWith(alias)) {
        return true;
      }
    }
    return false;
  }

  @override
  void onClose() {
    unawaited(disconnect());
    unawaited(_eventController.close());
    super.onClose();
  }
}
