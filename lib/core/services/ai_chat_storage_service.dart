import 'package:fresh_leaf/core/models/ai_chat_message.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AiChatStorageService extends GetxService {
  AiChatStorageService({GetStorage? box}) : _box = box ?? GetStorage();

  final GetStorage _box;
  static const String _messagesKey = 'ai_messages';

  List<AiChatMessage> loadMessages() {
    final stored = _box.read<List<dynamic>>(_messagesKey);
    if (stored == null) return [];
    return stored
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => AiChatMessage.fromMap(e.cast<String, dynamic>()))
        .toList();
  }

  Future<void> saveMessages(List<AiChatMessage> messages) async {
    final data = messages.map((m) => m.toMap()).toList();
    await _box.write(_messagesKey, data);
  }

  Future<void> clearMessages() async {
    await _box.remove(_messagesKey);
  }
}
