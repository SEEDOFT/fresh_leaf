import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/core/models/ai_chat_message.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/gemini_ai_chat_service.dart';
import 'package:get/get.dart';

class AiAssistantController extends GetxController {
  final RxBool isLoading = false.obs;
  final GeminiAiChatService _geminiService = GeminiAiChatService();
  final AiChatStorageService _storage = Get.find<AiChatStorageService>();
  final RxList<AiChatMessage> messages = <AiChatMessage>[].obs;
  final TextEditingController inputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  String? _inventoryContext;

  @override
  Future<void> onInit() async {
    super.onInit();
    _hydrateMessages();
    await _loadInventory();
  }

  @override
  void onReady() {
    super.onReady();
    _scheduleAutoScroll(animated: false);
  }

  // Load inventory from file
  Future<void> _loadInventory() async {
    try {
      _inventoryContext = await rootBundle.loadString(
        'assets/ai_context/produce_inventory.md',
      );
    } on Exception catch (_) {
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

    messages.add(AiChatMessage(text: prompt, isUser: true));
    await _persistMessages();
    _scheduleAutoScroll();
    inputController.clear();

    messages.add(
      const AiChatMessage(text: '', isUser: false, isStreaming: true),
    );
    final aiIndex = messages.length - 1;
    await _persistMessages();
    _scheduleAutoScroll();

    isLoading.value = true;
    try {
      final buffer = StringBuffer();
      final stream = _geminiService.streamResponse(fullPrompt);
      await for (final chunk in stream) {
        buffer.write(chunk);
        messages[aiIndex] = messages[aiIndex].copyWith(
          text: buffer.toString(),
          isStreaming: true,
        );
        await _persistMessages();
        _scheduleAutoScroll(animated: false);
      }
      messages[aiIndex] = messages[aiIndex].copyWith(isStreaming: false);
      await _persistMessages();
      _scheduleAutoScroll();
    } on Exception catch (e) {
      messages[aiIndex] = AiChatMessage(
        text: 'Error: $e',
        isUser: false,
      );
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
  void onClose() {
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
}
