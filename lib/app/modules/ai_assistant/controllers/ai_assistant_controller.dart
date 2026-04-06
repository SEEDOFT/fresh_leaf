import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/models/ai_chat_message.dart';
import 'package:fresh_leaf/core/models/ai_chat_send_message_result.dart';
import 'package:fresh_leaf/core/models/ai_chat_realtime_event.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:get/get.dart';

class AiAssistantController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString responseSource = 'idle'.obs;
  final AiChatStorageService _storage = Get.find<AiChatStorageService>();
  final AiAssistantApiService _apiService = Get.find<AiAssistantApiService>();
  final AiAssistantRealtimeService _realtimeService =
      Get.find<AiAssistantRealtimeService>();
  final RxList<AiChatMessage> messages = <AiChatMessage>[].obs;
  final TextEditingController inputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  String? _sessionId;
  String? _userId;
  StreamSubscription<AiChatRealtimeEvent>? _realtimeSubscription;
  Timer? _streamWatchdog;

  @override
  Future<void> onInit() async {
    super.onInit();
    _hydrateMessages();
    await _initializeRealtimeChat();
  }

  @override
  void onReady() {
    super.onReady();
    _scheduleAutoScroll(animated: false);
  }

  Future<void> _initializeRealtimeChat() async {
    if (_sessionId != null && _userId != null) {
      return;
    }

    try {
      _userId = await _apiService.resolveUserId();
      final session = await _apiService.createSession();
      _sessionId = session.sessionId;

      await _realtimeService.subscribeToSessionChannel(
        userId: _userId!,
        sessionId: _sessionId!,
      );

      _realtimeSubscription ??= _realtimeService.events.listen(
        _handleRealtimeEvent,
      );

      final history = await _apiService.fetchHistory(
        sessionId: _sessionId!,
      );
      if (history.isNotEmpty) {
        messages.assignAll(history);
      }

      await _persistMessages();
      _scheduleAutoScroll(animated: false);
    } on Exception catch (_) {
      // App still allows local compose; backend may be temporarily unavailable.
    }
  }

  Future<void> sendMessage() async {
    final prompt = inputController.text.trim();
    if (prompt.isEmpty || isLoading.value) return;

    await _initializeRealtimeChat();
    final sessionId = _sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      Get.snackbar(
        'fetch_failed'.tr,
        'unable_connect_chat_realtime'.tr,
      );
      return;
    }

    messages.add(
      AiChatMessage(
        text: prompt,
        isUser: true,
        sessionId: sessionId,
      ),
    );
    await _persistMessages();
    _scheduleAutoScroll();
    inputController.clear();

    messages.add(
      AiChatMessage(
        text: '',
        isUser: false,
        isStreaming: true,
        sessionId: sessionId,
        status: 'streaming',
      ),
    );
    await _persistMessages();
    _scheduleAutoScroll();
    _restartStreamWatchdog();
    responseSource.value = 'pending';

    isLoading.value = true;
    try {
      final sendResult = await _apiService.sendMessage(
        sessionId: sessionId,
        message: prompt,
      );
      unawaited(
        _pollHistoryFallback(
          sendResult: sendResult,
        ),
      );
    } on Exception catch (error) {
      final lastIndex = _latestAssistantStreamingIndex();
      if (lastIndex >= 0) {
        messages[lastIndex] = messages[lastIndex].copyWith(
          text: _apiService.parseError(
            error,
            fallback: 'unable_send_chat_message'.tr,
          ),
          isStreaming: false,
          status: 'failed',
        );
      }
      _stopStreamWatchdog();
      await _persistMessages();
      _scheduleAutoScroll();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (text.isNotEmpty) {
      Get.snackbar(
        'copied'.tr,
        'message_copied'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  @override
  Future<void> onClose() async {
    await _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    _stopStreamWatchdog();
    unawaited(_realtimeService.disconnect());
    inputController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }

  void _hydrateMessages() {
    final loaded = _storage.loadMessages();
    if (loaded.isNotEmpty) {
      messages.assignAll(loaded);
    }
  }

  void _scheduleAutoScroll({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!chatScrollController.hasClients) return;
      final target = chatScrollController.position.maxScrollExtent;
      if (animated) {
        await chatScrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      } else {
        chatScrollController.jumpTo(target);
      }
    });
  }

  Future<void> _persistMessages() async {
    await _storage.saveMessages(messages.toList());
  }

  Future<void> clearHistory() async {
    messages.clear();
    await _storage.clearMessages();
  }

  void _handleRealtimeEvent(AiChatRealtimeEvent event) {
    if (_sessionId != null && event.sessionId.isNotEmpty) {
      if (event.sessionId != _sessionId) {
        return;
      }
    }

    if (event.isStarted || event.isChunk) {
      _upsertStreamingMessage(event);
      _restartStreamWatchdog();
      responseSource.value = 'realtime';
    } else if (event.isCompleted) {
      _completeStreamingMessage(event);
      _stopStreamWatchdog();
      responseSource.value = 'realtime';
    } else if (event.isFailed) {
      _failStreamingMessage(event);
      _stopStreamWatchdog();
      responseSource.value = 'realtime_failed';
    }

    unawaited(_persistMessages());
    _scheduleAutoScroll(animated: false);
  }

  void _upsertStreamingMessage(AiChatRealtimeEvent event) {
    final messageIndex = _indexByMessageId(event.messageId);
    if (messageIndex >= 0) {
      final current = messages[messageIndex];
      messages[messageIndex] = current.copyWith(
        text: current.text + event.textChunk,
        isStreaming: true,
        sessionId: event.sessionId,
        messageId: event.messageId,
        sequence: event.sequence,
        status: 'streaming',
      );
      return;
    }

    final placeholderIndex = _latestAssistantStreamingIndex();
    if (placeholderIndex >= 0) {
      final current = messages[placeholderIndex];
      messages[placeholderIndex] = current.copyWith(
        text: current.text + event.textChunk,
        isStreaming: true,
        sessionId: event.sessionId,
        messageId: event.messageId,
        sequence: event.sequence,
        status: 'streaming',
      );
      return;
    }

    messages.add(
      AiChatMessage(
        text: event.textChunk,
        isUser: false,
        isStreaming: true,
        sessionId: event.sessionId,
        messageId: event.messageId,
        sequence: event.sequence,
        status: 'streaming',
      ),
    );
  }

  void _completeStreamingMessage(AiChatRealtimeEvent event) {
    final messageIndex = _indexByMessageId(event.messageId);
    final finalText = event.fullText.isNotEmpty
        ? event.fullText
        : event.textChunk;

    if (messageIndex >= 0) {
      messages[messageIndex] = messages[messageIndex].copyWith(
        text: finalText,
        isStreaming: false,
        sequence: event.sequence,
        status: 'done',
      );
      return;
    }

    final placeholderIndex = _latestAssistantStreamingIndex();
    if (placeholderIndex >= 0) {
      final current = messages[placeholderIndex];
      messages[placeholderIndex] = current.copyWith(
        text: finalText.isNotEmpty ? finalText : current.text,
        isStreaming: false,
        sessionId: event.sessionId,
        messageId: event.messageId,
        sequence: event.sequence,
        status: 'done',
      );
      return;
    }

    messages.add(
      AiChatMessage(
        text: finalText,
        isUser: false,
        isStreaming: false,
        sessionId: event.sessionId,
        messageId: event.messageId,
        sequence: event.sequence,
        status: 'done',
      ),
    );
  }

  void _failStreamingMessage(AiChatRealtimeEvent event) {
    final messageIndex = _indexByMessageId(event.messageId);
    final errorText = event.fullText.isNotEmpty
        ? event.fullText
        : event.textChunk;

    if (messageIndex >= 0) {
      messages[messageIndex] = messages[messageIndex].copyWith(
        text: errorText,
        isStreaming: false,
        sequence: event.sequence,
        status: 'failed',
      );
      return;
    }

    final placeholderIndex = _latestAssistantStreamingIndex();
    if (placeholderIndex >= 0) {
      messages[placeholderIndex] = messages[placeholderIndex].copyWith(
        text: errorText,
        isStreaming: false,
        sequence: event.sequence,
        status: 'failed',
      );
      return;
    }

    messages.add(
      AiChatMessage(
        text: errorText,
        isUser: false,
        isStreaming: false,
        sessionId: event.sessionId,
        messageId: event.messageId,
        sequence: event.sequence,
        status: 'failed',
      ),
    );
  }

  int _indexByMessageId(String messageId) {
    if (messageId.isEmpty) {
      return -1;
    }

    return messages.indexWhere(
      (message) => message.messageId == messageId,
    );
  }

  int _latestAssistantStreamingIndex() {
    for (var index = messages.length - 1; index >= 0; index--) {
      final message = messages[index];
      if (!message.isUser && message.isStreaming) {
        return index;
      }
    }
    return -1;
  }

  Future<void> _pollHistoryFallback({
    required AiChatSendMessageResult sendResult,
  }) async {
    const maxAttempts = 60;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (isClosed) {
        return;
      }

      final streamingIndex = _latestAssistantStreamingIndex();
      if (streamingIndex < 0) {
        return;
      }

      await Future<void>.delayed(const Duration(seconds: 1));
      try {
        final history = await _apiService.fetchHistory(
          sessionId: sendResult.sessionId,
        );
        if (history.isEmpty) {
          continue;
        }

        final assistantMessage = _resolveAssistantMessage(
          history: history,
          assistantMessageId: sendResult.assistantMessageId,
        );
        if (assistantMessage == null) {
          continue;
        }

        final index = _latestAssistantStreamingIndex();
        if (index < 0) {
          return;
        }

        final isTerminal = assistantMessage.status == 'done' ||
            assistantMessage.status == 'failed';

        messages[index] = messages[index].copyWith(
          text: assistantMessage.text,
          isStreaming: !isTerminal,
          sessionId: assistantMessage.sessionId,
          messageId: assistantMessage.messageId,
          sequence: assistantMessage.sequence,
          status: assistantMessage.status,
        );
        responseSource.value = 'history_fallback';
        unawaited(_persistMessages());
        _scheduleAutoScroll(animated: false);

        if (isTerminal && assistantMessage.text.trim().isNotEmpty) {
          _stopStreamWatchdog();
          return;
        }
      } on Exception {
        // Keep polling until timeout.
      }
    }
  }

  AiChatMessage? _resolveAssistantMessage({
    required List<AiChatMessage> history,
    required String assistantMessageId,
  }) {
    if (assistantMessageId.isNotEmpty) {
      for (var index = history.length - 1; index >= 0; index--) {
        final message = history[index];
        if (!message.isUser && message.messageId == assistantMessageId) {
          return message;
        }
      }
    }

    for (var index = history.length - 1; index >= 0; index--) {
      final message = history[index];
      if (!message.isUser) {
        return message;
      }
    }
    return null;
  }

  void _restartStreamWatchdog() {
    _streamWatchdog?.cancel();
    _streamWatchdog = Timer(const Duration(minutes: 1), () {
      final lastIndex = _latestAssistantStreamingIndex();
      if (lastIndex < 0) {
        return;
      }
      messages[lastIndex] = messages[lastIndex].copyWith(
        text: 'Unable to receive realtime response. Please try again.',
        isStreaming: false,
        status: 'failed',
      );
      responseSource.value = 'timeout_failed';
      unawaited(_persistMessages());
      _scheduleAutoScroll();
    });
  }

  void _stopStreamWatchdog() {
    _streamWatchdog?.cancel();
    _streamWatchdog = null;
  }
}
