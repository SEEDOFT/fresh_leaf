import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fresh_leaf/core/config/app_config.dart';
import 'package:fresh_leaf/core/models/support_message.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SupportRealtimeService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final StreamController<SupportMessage> _messageController =
      StreamController<SupportMessage>.broadcast();
  final StreamController<String> _typingController =
      StreamController<String>.broadcast();
  final Dio _dio = Dio();

  WebSocketChannel? _socketChannel;
  StreamSubscription<dynamic>? _socketSubscription;
  Completer<void>? _connectionCompleter;
  Completer<void>? _subscriptionCompleter;

  String _socketId = '';
  String _activeChannel = '';
  bool _isConnected = false;

  Stream<SupportMessage> get messages => _messageController.stream;
  Stream<String> get typingEvents => _typingController.stream;

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
    } on Exception {
      _connectionCompleter = null;
      rethrow;
    } finally {
      _connectionCompleter = null;
    }
  }

  Future<void> subscribeToTicket(int ticketId) async {
    await connect();
    final channelName = 'private-support.ticket.$ticketId';
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

  Future<Map<String, dynamic>> _authorize(
    String channel,
    String socketId,
  ) async {
    final token = _storageService.token;
    final response = await _dio.post<Map<String, dynamic>>(
      AppConfig.reverbAuthEndpoint,
      data: {'socket_id': socketId, 'channel_name': channel},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
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
    } else if (event == 'pusher_internal:subscription_succeeded') {
      _subscriptionCompleter?.complete();
    } else if (event == 'SupportMessageSent') {
      final messageData =
          jsonDecode(data['data'] as String) as Map<String, dynamic>;
      _messageController.add(SupportMessage.fromMap(messageData));
    } else if (event == 'SupportTyping') {
      final typingData =
          jsonDecode(data['data'] as String) as Map<String, dynamic>;
      _typingController.add(typingData['sender_type'] as String);
    }
  }

  void _sendRaw(Map<String, dynamic> data) =>
      _socketChannel?.sink.add(jsonEncode(data));

  void _handleSocketError() {
    _isConnected = false;
    _connectionCompleter?.completeError('Socket error');
  }

  void _handleSocketDone() => _isConnected = false;

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
    unawaited(_socketSubscription?.cancel());
    unawaited(_socketChannel?.sink.close());
    unawaited(_messageController.close());
    super.onClose();
  }
}
