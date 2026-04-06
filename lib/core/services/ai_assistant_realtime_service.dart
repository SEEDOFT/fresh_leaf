import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  final RxString connectionState = 'DISCONNECTED'.obs;
  final RxString subscriptionState = 'idle'.obs;
  final RxString activeChannelName = ''.obs;
  final RxString lastEventName = ''.obs;
  final RxString lastError = ''.obs;
  final RxString authState = 'idle'.obs;

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
    connectionState.value = 'CONNECTING';
    lastError.value = '';
    _trace('connect ${_buildSocketUri()}');

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
      activeChannelName.value = '';
    }

    await _socketSubscription?.cancel();
    _socketSubscription = null;
    await _socketChannel?.sink.close();
    _socketChannel = null;

    _socketId = '';
    _pendingChannel = '';
    _isConnected = false;
    connectionState.value = 'DISCONNECTED';
    subscriptionState.value = 'idle';
  }

  Future<void> subscribeToSessionChannel({
    required String userId,
    required String sessionId,
  }) async {
    await connect();

    final channelName = 'private-ai-chat.$userId.$sessionId';
    if (_activeChannel == channelName && subscriptionState.value == 'ok') {
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
      activeChannelName.value = '';
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
    activeChannelName.value = channelName;
    subscriptionState.value = 'subscribing';
    lastError.value = '';
    _trace('subscribe $channelName');

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
      subscriptionState.value = 'ok';
      _trace('subscription ok $channelName');
    } on TimeoutException {
      subscriptionState.value = 'failed';
      lastError.value = 'Subscription timeout';
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

    authState.value = 'authorizing';
    _trace('authorizer request $channelName');

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

      authState.value = 'authorized';
      return data;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final message = 'auth failed (${statusCode ?? '-'})';
      authState.value = message;
      lastError.value = message;
      _trace(message);
      rethrow;
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

    lastEventName.value = eventName;
    _trace('event $eventName');

    if (eventName == 'pusher:connection_established') {
      _onConnectionEstablished(message['data']);
      return;
    }

    if (eventName == 'pusher:error') {
      _onPusherError(message['data']);
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
        subscriptionState.value = 'failed';
        lastError.value = errorMessage;
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
    connectionState.value = 'CONNECTED';
    _completeConnectionSuccess();
    _trace('connected socket_id=$socketId');
  }

  void _onPusherError(dynamic data) {
    final errorData = _decodeMap(data);
    final errorText = _toString(errorData['message']).isEmpty
        ? 'Realtime connection error'
        : _toString(errorData['message']);
    lastError.value = errorText;
    connectionState.value = 'ERROR';
    _completeConnectionError(FormatException(errorText));
    _completeSubscriptionError(FormatException(errorText));
    _emitFailureEvent(errorText);
  }

  void _onSubscriptionSucceeded(Map<String, dynamic> message) {
    final channelName = _toString(message['channel']);
    if (_pendingChannel.isNotEmpty && channelName != _pendingChannel) {
      return;
    }

    subscriptionState.value = 'ok';
    lastError.value = '';
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
    connectionState.value = 'ERROR';
    final message = error.toString();
    lastError.value = message;
    _completeConnectionError(error);
    _completeSubscriptionError(error);
    _emitFailureEvent(message);
  }

  void _handleSocketDone() {
    _isConnected = false;
    connectionState.value = 'DISCONNECTED';
    _socketId = '';
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
    if (eventName == AiChatEventType.messageStarted ||
        eventName.endsWith(AiChatEventType.messageStarted)) {
      return AiChatEventType.messageStarted;
    }
    if (eventName == AiChatEventType.messageChunk ||
        eventName.endsWith(AiChatEventType.messageChunk)) {
      return AiChatEventType.messageChunk;
    }
    if (eventName == AiChatEventType.messageCompleted ||
        eventName.endsWith(AiChatEventType.messageCompleted)) {
      return AiChatEventType.messageCompleted;
    }
    if (eventName == AiChatEventType.messageFailed ||
        eventName.endsWith(AiChatEventType.messageFailed)) {
      return AiChatEventType.messageFailed;
    }
    return null;
  }

  void _trace(String message) {
    debugPrint('[AI-RT] $message');
  }

  @override
  void onClose() {
    unawaited(disconnect());
    unawaited(_eventController.close());
    super.onClose();
  }
}
