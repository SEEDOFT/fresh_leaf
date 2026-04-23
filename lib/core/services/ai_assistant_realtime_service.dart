import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fresh_leaf/core/config/app_config.dart';
import 'package:fresh_leaf/core/models/ai_chat_realtime_event.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class AiAssistantRealtimeService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final StreamController<AiChatRealtimeEvent> _eventController =
      StreamController<AiChatRealtimeEvent>.broadcast();
  final Dio _dio = Dio();
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  Completer<void>? _connectionCompleter;
  Completer<void>? _subscriptionCompleter;

  String _activeChannel = '';
  String _pendingChannel = '';
  bool _isInitialized = false;
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

    try {
      await _ensureInitialized();
      await _pusher.connect();
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
      await _safeUnsubscribe(_activeChannel);
    }
    _activeChannel = '';
    _pendingChannel = '';
    _isConnected = false;
    await _pusher.disconnect();
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
      await _safeUnsubscribe(_activeChannel);
      _activeChannel = '';
    }

    _pendingChannel = channelName;
    _subscriptionCompleter = Completer<void>();

    try {
      await _pusher.subscribe(channelName: channelName);
      await _subscriptionCompleter!.future.timeout(
        const Duration(seconds: 10),
      );
      _activeChannel = channelName;
      _pendingChannel = '';
    } on TimeoutException {
      _pendingChannel = '';
      throw TimeoutException('Realtime channel subscribe timeout');
    } finally {
      _subscriptionCompleter = null;
    }
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) {
      return;
    }

    final isSecure = AppConfig.reverbWebSocketScheme.toLowerCase() == 'wss';

    await _pusher.init(
      apiKey: AppConfig.reverbAppKey,
      cluster: '',
      useTLS: isSecure,
      authEndpoint: AppConfig.reverbAuthEndpoint,
      onConnectionStateChange: _onConnectionStateChange,
      onSubscriptionSucceeded: _onSubscriptionSucceeded,
      onSubscriptionError: _onSubscriptionError,
      onError: _onError,
      onEvent: _onEvent,
      onAuthorizer: _onAuthorizer,
    );

    await _reinitializeWithReverbHost(
      isSecure: isSecure,
    );

    _isInitialized = true;
  }

  Future<void> _reinitializeWithReverbHost({
    required bool isSecure,
  }) async {
    final initPayload = <String, dynamic>{
      'apiKey': AppConfig.reverbAppKey,
      'cluster': '',
      'host': AppConfig.reverbWebSocketHost,
      'wsPort': AppConfig.reverbWebSocketPort,
      'wssPort': AppConfig.reverbWebSocketPort,
      'useTLS': isSecure,
      'authEndpoint': AppConfig.reverbAuthEndpoint,
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android plugin implementation checks `authorizer` as String.
      initPayload['authorizer'] = 'true';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS plugin implementation checks `authorizer` as Bool.
      initPayload['authorizer'] = true;
    }

    await _pusher.methodChannel.invokeMethod('init', initPayload);
  }

  Future<dynamic> _onAuthorizer(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    try {
      return await _authorizePrivateChannel(
        channelName: channelName,
        socketId: socketId,
      );
    } on Exception catch (error) {
      final message = error.toString();
      _emitFailureEvent(message);
      rethrow;
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
      final authPayload = _extractAuthorizerPayload(data);
      final auth = _toString(authPayload['auth']);
      if (auth.isEmpty) {
        throw const FormatException('Invalid auth response from backend');
      }

      return authPayload;
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

  Map<String, dynamic> _extractAuthorizerPayload(dynamic data) {
    final root = _decodeMap(data);
    if (root.containsKey('auth')) {
      return root;
    }

    final nested = _decodeMap(root['data']);
    if (nested.containsKey('auth')) {
      return nested;
    }

    return root;
  }

  Future<void> _safeUnsubscribe(String channelName) async {
    try {
      await _pusher.unsubscribe(channelName: channelName);
    } on Exception {
      // Ignore unsubscribe errors during channel switches/disconnect.
    }
  }

  void _onConnectionStateChange(String currentState, String _previousState) {
    final state = currentState.toUpperCase();
    if (state == 'CONNECTED') {
      _isConnected = true;
      _completeConnectionSuccess();
      return;
    }

    if (state == 'DISCONNECTED' || state == 'UNAVAILABLE' || state == 'FAILED') {
      _isConnected = false;
      _completeConnectionError(
        FormatException('Realtime connection state: $currentState'),
      );
    }
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    if (_pendingChannel.isNotEmpty && _pendingChannel != channelName) {
      return;
    }
    _activeChannel = channelName;
    _pendingChannel = '';
    _completeSubscriptionSuccess();
  }

  void _onSubscriptionError(String message, dynamic _error) {
    _completeSubscriptionError(FormatException(message));
    _emitFailureEvent(message);
  }

  void _onError(String message, int? _code, dynamic _error) {
    _isConnected = false;
    _completeConnectionError(FormatException(message));
    _completeSubscriptionError(FormatException(message));
    _emitFailureEvent(message);
  }

  void _onEvent(PusherEvent event) {
    final eventName = event.eventName;
    if (eventName == 'pusher:subscription_succeeded' ||
        eventName == 'pusher_internal:subscription_succeeded') {
      _onSubscriptionSucceeded(event.channelName, event.data);
      return;
    }

    final resolvedEventType = _resolveEventType(eventName);
    if (resolvedEventType == null) {
      return;
    }

    final payload = _decodeMap(event.data);
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
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return decoded.map<String, dynamic>(
            (key, value) => MapEntry<String, dynamic>(key.toString(), value),
          );
        }
      } on FormatException {
        return <String, dynamic>{};
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
