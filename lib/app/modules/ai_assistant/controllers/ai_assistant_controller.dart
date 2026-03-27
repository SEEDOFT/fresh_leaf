import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/gemini_ai_chat_service.dart';
import 'package:get/get.dart';

class AiAssistantController extends GetxController {
  final GeminiAiChatService _geminiService = GeminiAiChatService();
  final AiChatStorageService _storage = Get.find<AiChatStorageService>();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final RxBool isLoading = false.obs;
  final TextEditingController inputController = TextEditingController();

  String? _inventoryContext;

  @override
  void onInit() {
    super.onInit();
    _hydrateMessages();
    _loadInventory();
  }

  // Load inventory from file
  Future<void> _loadInventory() async {
    try {
      _inventoryContext = await rootBundle.loadString(
        'assets/ai_context/produce_inventory.md',
      );
    } catch (_) {
      _inventoryContext = null;
    }
  }

  // Send message to AI
  Future<void> sendMessage() async {
    final prompt = inputController.text.trim();
    if (prompt.isEmpty || isLoading.value) return;

    final fullPrompt = _inventoryContext == null
        ? prompt
        : 'Store inventory:\n$_inventoryContext\n\nUser: $prompt\nAI:';

    messages.add(ChatMessage(text: prompt, isUser: true));
    _persistMessages();
    inputController.clear();

    messages.add(const ChatMessage(text: '', isUser: false, isStreaming: true));
    final int aiIndex = messages.length - 1;
    _persistMessages();

    isLoading.value = true;
    try {
      var buffer = '';
      final stream = _geminiService.streamResponse(fullPrompt);
      await for (final chunk in stream) {
        buffer += chunk;
        messages[aiIndex] = messages[aiIndex].copyWith(
          text: buffer,
          isStreaming: true,
        );
        _persistMessages();
      }
      messages[aiIndex] = messages[aiIndex].copyWith(isStreaming: false);
      _persistMessages();
    } catch (e) {
      messages[aiIndex] = ChatMessage(
        text: 'Error: $e',
        isUser: false,
        isStreaming: false,
      );
      _persistMessages();
    } finally {
      isLoading.value = false;
    }
  }

  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    if (text.isNotEmpty) {
      Get.snackbar(
        'Copied',
        'Message copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  void _hydrateMessages() {
    final loaded = _storage.loadMessages();
    if (loaded.isNotEmpty) {
      messages.assignAll(loaded);
    }
  }

  void _persistMessages() {
    _storage.saveMessages(messages.toList());
  }

  Future<void> clearHistory() async {
    messages.clear();
    await _storage.clearMessages();
  }
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
  });

  final String text;
  final bool isUser;
  final bool isStreaming;

  ChatMessage copyWith({String? text, bool? isUser, bool? isStreaming}) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  Map<String, dynamic> toMap() => {
    'text': text,
    'isUser': isUser,
    'isStreaming': isStreaming,
  };

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] as String? ?? '',
      isUser: map['isUser'] as bool? ?? false,
      isStreaming: map['isStreaming'] as bool? ?? false,
    );
  }
}
