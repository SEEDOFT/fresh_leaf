import 'dart:async';
import 'dart:convert';

import 'package:fresh_leaf/core/config/app_config.dart';
import 'package:fresh_leaf/core/models/chat_message.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart' hide FormData;
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRealtimeService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();
  final StreamController<int> _typingController =
      StreamController<int>.broadcast();

  WebSocketChannel? _socketChannel;
  StreamSubscription<dynamic>? _socketSubscription;
  Completer<void>? _connectionCompleter;
  Completer<void>? _subscriptionCompleter;

  Timer? _reconnectTimer;
  Timer? _pingTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);
  static const Duration _pingInterval = Duration(seconds: 30);

  String _socketId = '';
  String _activeChannel = '';
  bool _isConnected = false;
  int? _currentConversationId;

  Stream<ChatMessage> get messages => _messageController.stream;
  Stream<int> get typingEvents => _typingController.stream;

  String get socketId => _socketId;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) return;
    if (_connectionCompleter != null) {
      await _connectionCompleter!.future;
      return;
    }

    _connectionCompleter = Completer<void>();
    final channel = WebSocketChannel.connect(_buildSocketUri());
    _socketChannel = channel;
    _socketSubscription = channel.stream.listen(
      _handleSocketMessage,
      onError: (_) => _handleSocketError(),
      onDone: _handleSocketDone,
    );

    try {
      await _connectionCompleter!.future.timeout(const Duration(seconds: 15));
      _startPingTimer();
      _reconnectAttempts = 0;
    } on TimeoutException {
      _connectionCompleter = null;
      _scheduleReconnect();
    } on Exception {
      _connectionCompleter = null;
      _scheduleReconnect();
      rethrow;
    } finally {
      _connectionCompleter = null;
    }
  }

  Future<void> subscribeToConversation(int conversationId) async {
    _currentConversationId = conversationId;
    await connect();
    final channelName = 'private-chat.conversation.$conversationId';
    if (_activeChannel == channelName && _isConnected) return;

    if (_socketId.isEmpty) throw const FormatException('Missing socket id');

    final authPayload = await _authorize(channelName, _socketId);
    _subscriptionCompleter = Completer<void>();

    _sendRaw({
      'event': 'pusher:subscribe',
      'data': {
        'channel': channelName,
        'auth': authPayload['auth'],
        if (authPayload['channel_data'] != null)
          'channel_data': authPayload['channel_data'],
      },
    });

    await _subscriptionCompleter!.future.timeout(const Duration(seconds: 10));
    _activeChannel = channelName;
    _subscriptionCompleter = null;
  }

  Future<void> resubscribe() async {
    if (_currentConversationId != null && _isConnected) {
      await subscribeToConversation(_currentConversationId!);
    }
  }

  Future<Map<String, dynamic>> _authorize(
    String channel,
    String socketId,
  ) async {
    final response = await _apiClient.postRequest(
      AppConfig.reverbAuthEndpoint,
      data: <String, dynamic>{
        'socket_id': socketId,
        'channel_name': channel,
      },
    );
    return response.data ?? <String, dynamic>{};
  }

  void _handleSocketMessage(dynamic payload) {
    final data = jsonDecode(payload as String) as Map<String, dynamic>;
    final event = data['event'] as String;

    if (event == 'pusher:connection_established') {
      final decodedData =
          jsonDecode(data['data'] as String) as Map<String, dynamic>;
      _socketId = decodedData['socket_id'] as String;
      _isConnected = true;
      _connectionCompleter?.complete();
      _reconnectAttempts = 0;
    } else if (event == 'pusher_internal:subscription_succeeded') {
      _subscriptionCompleter?.complete();
    } else if (event == 'ChatMessageSent') {
      final messageData =
          jsonDecode(data['data'] as String) as Map<String, dynamic>;
      _messageController.add(ChatMessage.fromMap(messageData));
    } else if (event == 'ChatTyping') {
      final typingData =
          jsonDecode(data['data'] as String) as Map<String, dynamic>;
      _typingController.add(typingData['senderId'] as int);
    } else if (event == 'pusher:ping') {
      _sendRaw(<String, dynamic>{
        'event': 'pusher:pong',
        'data': '{}',
      });
    }
  }

  void _sendRaw(Map<String, dynamic> data) =>
      _socketChannel?.sink.add(jsonEncode(data));

  void _handleSocketError() {
    _isConnected = false;
    _stopPingTimer();
    _connectionCompleter?.completeError('Socket error');
    _scheduleReconnect();
  }

  void _handleSocketDone() {
    _isConnected = false;
    _stopPingTimer();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () async {
      _reconnectAttempts++;
      try {
        await connect();
        if (_currentConversationId != null) {
          await resubscribe();
        }
      } on Exception {
        // Reconnect will be scheduled again by error handler
      }
    });
  }

  void _startPingTimer() {
    _stopPingTimer();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_isConnected && _socketId.isNotEmpty) {
        _sendRaw(<String, dynamic>{
          'event': 'pusher:ping',
          'data': '{}',
        });
      }
    });
  }

  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  Uri _buildSocketUri() {
    final isSecure = AppConfig.reverbWebSocketScheme.toLowerCase() == 'wss';
    return Uri(
      scheme: isSecure ? 'wss' : 'ws',
      host: AppConfig.reverbWebSocketHost,
      port: AppConfig.reverbWebSocketPort,
      path: '/app/${AppConfig.reverbAppKey}',
      queryParameters: {
        'protocol': '7',
        'client': 'flutter',
        'version': '1.0',
      },
    );
  }

  @override
  void onClose() {
    _reconnectTimer?.cancel();
    _stopPingTimer();
    unawaited(_socketSubscription?.cancel());
    unawaited(_socketChannel?.sink.close());
    unawaited(_messageController.close());
    unawaited(_typingController.close());
    super.onClose();
  }
}
