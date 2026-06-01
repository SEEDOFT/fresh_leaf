import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/models/ai_chat_message.dart';
import 'package:fresh_leaf/core/models/ai_chat_realtime_event.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:get/get.dart';

class AiAssistantController extends GetxController {
  AiAssistantController({
    required AiChatStorageService aiChatStorageService,
    required AiAssistantApiService aiAssistantApiService,
    required AiAssistantRealtimeService aiAssistantRealtimeService,
  }) : _storage = aiChatStorageService,
       _apiService = aiAssistantApiService,
       _realtimeService = aiAssistantRealtimeService;
  static const Duration _aiResponseTimeout = Duration(seconds: 45);

  final RxBool isLoading = false.obs;
  final RxBool isAiServiceAvailable = true.obs;
  final RxBool isRealtimeReady = false.obs;
  final RxString lastRealtimeError = ''.obs;
  final AiChatStorageService _storage;
  final AiAssistantApiService _apiService;
  final AiAssistantRealtimeService _realtimeService;
  final RxList<AiChatMessage> messages = <AiChatMessage>[].obs;
  final TextEditingController inputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  String? _sessionId;
  String? _userId;
  bool _historyLoaded = false;
  StreamSubscription<AiChatRealtimeEvent>? _realtimeSubscription;
  Completer<bool>? _realtimeInitCompleter;
  Timer? _streamWatchdog;
  Timer? _persistDebounceTimer;
  Timer? _scrollDebounceTimer;

  @override
  Future<void> onInit() async {
    super.onInit();
    _hydrateMessages();
    await checkAiServiceStatus();
    await _initializeRealtimeChat(showError: false);
  }

  Future<void> checkAiServiceStatus() async {
    try {
      isAiServiceAvailable.value = await _apiService.checkStatus();
    } on Exception {
      isAiServiceAvailable.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _scheduleAutoScroll(animated: false);
  }

  /// Initializes user/session/realtime state and loads history once.
  ///
  /// Sequencing: chat is considered ready only after private-channel
  /// subscription succeeds and event listener is attached.
  /// Side effects: updates `isRealtimeReady`, `lastRealtimeError`,
  /// `_sessionId`, `_userId`, and `_historyLoaded`.
  Future<bool> _initializeRealtimeChat({required bool showError}) async {
    if (isRealtimeReady.value && _sessionId != null && _userId != null) {
      return true;
    }

    if (_realtimeInitCompleter != null) {
      return _realtimeInitCompleter!.future;
    }

    final completer = Completer<bool>();
    _realtimeInitCompleter = completer;

    try {
      _userId ??= await _apiService.resolveUserId();
      if (_sessionId == null || _sessionId!.isEmpty) {
        final session = await _apiService.createSession();
        _sessionId = session['session_id'] as String?;
        _historyLoaded = false;
      }

      _realtimeSubscription ??= _realtimeService.events.listen(
        _handleRealtimeEvent,
      );

      await _realtimeService.subscribeToSessionChannel(
        userId: _userId!,
        sessionId: _sessionId!,
      );

      isRealtimeReady.value = true;
      lastRealtimeError.value = '';

      if (!_historyLoaded) {
        final history = await _apiService.fetchHistory(
          sessionId: _sessionId!,
        );
        if (history.isNotEmpty) {
          messages.assignAll(history);
        }
        _historyLoaded = true;
        _scheduleAutoScroll(animated: false);
      }

      completer.complete(true);
      return true;
    } on Exception catch (error) {
      final reason = _resolveRealtimeErrorMessage(error);
      isRealtimeReady.value = false;
      lastRealtimeError.value = reason;
      if (kDebugMode) {
        debugPrint('[AI][Realtime] init failed: $error');
      }

      if (showError) {
        Get.snackbar('fetch_failed'.tr, reason);
      }

      completer.complete(false);
      return false;
    } finally {
      _realtimeInitCompleter = null;
    }
  }

  Future<void> sendMessage() async {
    final prompt = inputController.text.trim();
    if (prompt.isEmpty || isLoading.value) return;

    final ready = await _ensureRealtimeReadyForSend();
    if (!ready) {
      return;
    }

    final sessionId = _sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      Get.snackbar(
        'fetch_failed'.tr,
        'unable_connect_chat_realtime'.tr,
      );
      return;
    }

    messages
      ..add(
        AiChatMessage(
          text: prompt,
          isUser: true,
          sessionId: sessionId,
        ),
      )
      ..add(
        AiChatMessage(
          text: '',
          isUser: false,
          isStreaming: true,
          sessionId: sessionId,
          status: 'streaming',
        ),
      );
    inputController.clear();
    await _persistMessages();
    _scheduleAutoScroll();
    _restartStreamWatchdog();

    isLoading.value = true;
    try {
      await _apiService.sendMessage(
        sessionId: sessionId,
        prompt: prompt,
      );
    } on Exception catch (error) {
      final errorText = _apiService.parseError(
        error,
        fallback: 'unable_send_chat_message'.tr,
      );
      final lastIndex = _latestAssistantStreamingIndex();
      if (lastIndex >= 0) {
        messages[lastIndex] = messages[lastIndex].copyWith(
          text: errorText,
          isStreaming: false,
          status: 'failed',
        );
      }
      _stopStreamWatchdog();
      await _persistMessages();
      _scheduleAutoScroll();
      Get.snackbar('fetch_failed'.tr, errorText);
    } finally {
      isLoading.value = false;
    }
  }

  /// Guarantees realtime readiness before a message POST is allowed.
  ///
  /// Sequencing: tries initialize once, then does one disconnect/retry cycle.
  /// Side effects: may show a snackbar and block send when WS is unavailable.
  Future<bool> _ensureRealtimeReadyForSend() async {
    final initialized = await _initializeRealtimeChat(showError: false);
    if (initialized) {
      return true;
    }

    if (kDebugMode) {
      debugPrint('[AI][Realtime] retrying connect/subscribe before send');
    }
    await _realtimeService.disconnect();
    isRealtimeReady.value = false;

    final retried = await _initializeRealtimeChat(showError: false);
    if (retried) {
      return true;
    }

    final reason = lastRealtimeError.value.isEmpty
        ? 'unable_connect_chat_realtime'.tr
        : lastRealtimeError.value;
    Get.snackbar('fetch_failed'.tr, reason);
    return false;
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
    _persistDebounceTimer?.cancel();
    _scrollDebounceTimer?.cancel();
    unawaited(_realtimeService.disconnect());
    isRealtimeReady.value = false;
    lastRealtimeError.value = '';
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

  /// Routes realtime events into UI message state transitions.
  ///
  /// Sequencing: only events for the active session are processed.
  /// Side effects: updates streaming/final/failed bubbles, watchdog lifecycle,
  /// persistence queue, and auto-scroll.
  void _handleRealtimeEvent(AiChatRealtimeEvent event) {
    if (event.isFailed && event.sessionId.isEmpty) {
      isRealtimeReady.value = false;
      final reason = event.fullText.isNotEmpty
          ? event.fullText
          : 'unable_connect_chat_realtime'.tr;
      lastRealtimeError.value = reason;
      if (kDebugMode) {
        debugPrint('[AI][Realtime] transport failure: $reason');
      }
      return;
    }

    if (_sessionId != null && event.sessionId.isNotEmpty) {
      if (event.sessionId != _sessionId) {
        return;
      }
    }

    if (event.isStarted || event.isChunk) {
      _upsertStreamingMessage(event);
      _restartStreamWatchdog();
      _queuePersistMessages();
      _queueAutoScroll();
      return;
    } else if (event.isCompleted) {
      _completeStreamingMessage(event);
      _stopStreamWatchdog();
      unawaited(_syncFinalAssistantMessage(event));
    } else if (event.isFailed) {
      _failStreamingMessage(event);
      _stopStreamWatchdog();
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
    final finalTextFromEvent = event.fullText.isNotEmpty
        ? event.fullText
        : event.textChunk;

    if (messageIndex >= 0) {
      final current = messages[messageIndex];
      final mergedText = event.fullText.isNotEmpty
          ? event.fullText
          : current.text + event.textChunk;
      messages[messageIndex] = messages[messageIndex].copyWith(
        text: mergedText,
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
        text: event.fullText.isNotEmpty
            ? event.fullText
            : (current.text + event.textChunk),
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
        text: finalTextFromEvent,
        isUser: false,
        sessionId: event.sessionId,
        messageId: event.messageId,
        sequence: event.sequence,
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

  /// Starts/refreshes timeout protection for an in-flight assistant stream.
  ///
  /// Sequencing: called when stream starts/chunks arrive and stopped on complete/fail.
  /// Side effects: converts the current streaming bubble to failed on timeout.
  void _restartStreamWatchdog() {
    _streamWatchdog?.cancel();
    _streamWatchdog = Timer(_aiResponseTimeout, () async {
      final lastIndex = _latestAssistantStreamingIndex();
      if (lastIndex < 0) {
        return;
      }

      final synced = await _syncLatestAssistantFromHistory(
        index: lastIndex,
        preferredMessageId: messages[lastIndex].messageId ?? '',
      );
      if (synced) {
        return;
      }

      messages[lastIndex] = messages[lastIndex].copyWith(
        text: 'ai_assistant_error_realtime'.tr,
        isStreaming: false,
        status: 'failed',
      );
      unawaited(_persistMessages());
      _scheduleAutoScroll();
    });
  }

  void _stopStreamWatchdog() {
    _streamWatchdog?.cancel();
    _streamWatchdog = null;
  }

  void _queuePersistMessages() {
    _persistDebounceTimer?.cancel();
    _persistDebounceTimer = Timer(
      const Duration(milliseconds: 350),
      () => unawaited(_persistMessages()),
    );
  }

  void _queueAutoScroll() {
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(
      const Duration(milliseconds: 80),
      () => _scheduleAutoScroll(animated: false),
    );
  }

  AiChatMessage? _latestAssistantMessage(List<AiChatMessage> history) {
    for (var index = history.length - 1; index >= 0; index--) {
      final message = history[index];
      if (!message.isUser) {
        return message;
      }
    }
    return null;
  }

  /// Performs one final history sync after `AiMessageCompleted`.
  ///
  /// Sequencing: this is a safety backup after stream completion,
  /// not active polling.
  /// Side effects: may replace the assistant bubble with server-final text.
  Future<void> _syncFinalAssistantMessage(AiChatRealtimeEvent event) async {
    final sessionId = _sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      return;
    }

    await _syncLatestAssistantFromHistory(
      preferredMessageId: event.messageId,
      index: event.messageId.isNotEmpty
          ? _indexByMessageId(event.messageId)
          : _latestAssistantIndex(),
    );
  }

  Future<bool> _syncLatestAssistantFromHistory({
    required String preferredMessageId,
    required int index,
  }) async {
    final sessionId = _sessionId;
    if (sessionId == null || sessionId.isEmpty || index < 0) {
      return false;
    }

    try {
      final history = await _apiService.fetchHistory(sessionId: sessionId);
      final finalAssistant = _resolveAssistantMessageFromHistory(
        history: history,
        preferredMessageId: preferredMessageId,
      );
      if (finalAssistant == null || finalAssistant.text.trim().isEmpty) {
        return false;
      }

      final current = messages[index];
      if (current.text == finalAssistant.text && !current.isStreaming) {
        return true;
      }

      messages[index] = current.copyWith(
        text: finalAssistant.text,
        isStreaming: false,
        sessionId: finalAssistant.sessionId,
        messageId: finalAssistant.messageId,
        sequence: finalAssistant.sequence,
        status: finalAssistant.status,
      );
      _queuePersistMessages();
      _queueAutoScroll();
      return true;
    } on Exception {
      // Keep event-stream result when sync fails.
      return false;
    }
  }

  AiChatMessage? _resolveAssistantMessageFromHistory({
    required List<AiChatMessage> history,
    required String preferredMessageId,
  }) {
    if (preferredMessageId.isNotEmpty) {
      for (var index = history.length - 1; index >= 0; index--) {
        final message = history[index];
        if (!message.isUser && message.messageId == preferredMessageId) {
          return message;
        }
      }
    }
    return _latestAssistantMessage(history);
  }

  int _latestAssistantIndex() {
    for (var index = messages.length - 1; index >= 0; index--) {
      if (!messages[index].isUser) {
        return index;
      }
    }
    return -1;
  }

  /// Maps low-level realtime errors into localized user-facing messages.
  ///
  /// Side effects: none; pure translation for diagnostics/snackbar usage.
  String _resolveRealtimeErrorMessage(Object error) {
    final lower = error.toString().toLowerCase();
    if (lower.contains('connect timeout')) {
      return 'chat_realtime_connect_timeout'.tr;
    }
    if (lower.contains('auth failed') || lower.contains('access token')) {
      return 'chat_realtime_auth_failed'.tr;
    }
    if (lower.contains('subscribe timeout') ||
        lower.contains('subscription failed')) {
      return 'chat_realtime_subscribe_failed'.tr;
    }
    if (lower.contains('connection closed') || lower.contains('disconnect')) {
      return 'chat_realtime_disconnected'.tr;
    }
    return 'unable_connect_chat_realtime'.tr;
  }
}
