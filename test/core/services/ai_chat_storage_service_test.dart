import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/core/models/ai_chat_message.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  late GetStorage box;
  late AiChatStorageService service;

  setUp(() async {
    PathProviderPlatform.instance = _FakePathProvider();
    await GetStorage.init('test_ai_chat');
    box = GetStorage('test_ai_chat');
    service = AiChatStorageService(box: box);
  });

  tearDown(() async {
    await box.erase();
  });

  group('AiChatStorageService', () {
    test('loadMessages returns empty list when nothing stored', () {
      final messages = service.loadMessages();
      expect(messages, isEmpty);
    });

    test('saveMessages stores and loadMessages retrieves', () async {
      final messages = [
        AiChatMessage(text: 'Hello', isUser: true, sessionId: 's1'),
        AiChatMessage(text: 'Hi', isUser: false, sessionId: 's1'),
      ];

      await service.saveMessages(messages);
      final loaded = service.loadMessages();

      expect(loaded.length, 2);
      expect(loaded[0].text, 'Hello');
      expect(loaded[0].isUser, isTrue);
      expect(loaded[1].text, 'Hi');
      expect(loaded[1].isUser, isFalse);
    });

    test('clearMessages removes stored messages', () async {
      await service.saveMessages([
        AiChatMessage(text: 'Test', isUser: true),
      ]);
      await service.clearMessages();

      final loaded = service.loadMessages();
      expect(loaded, isEmpty);
    });

    test('saveMessages overwrites previous data', () async {
      await service.saveMessages([
        AiChatMessage(text: 'First', isUser: true),
      ]);
      await service.saveMessages([
        AiChatMessage(text: 'Second', isUser: false),
      ]);

      final loaded = service.loadMessages();
      expect(loaded.length, 1);
      expect(loaded.first.text, 'Second');
    });

    test('round-trip preserves message fields', () async {
      final original = AiChatMessage(
        text: 'Roundtrip',
        isUser: true,
        isStreaming: true,
        sessionId: 'sess_rt',
        messageId: 'msg_rt',
        sequence: 7,
        status: 'streaming',
      );

      await service.saveMessages([original]);
      final loaded = service.loadMessages();

      expect(loaded.length, 1);
      expect(loaded.first.text, original.text);
      expect(loaded.first.isUser, original.isUser);
      expect(loaded.first.isStreaming, original.isStreaming);
      expect(loaded.first.sessionId, original.sessionId);
      expect(loaded.first.messageId, original.messageId);
      expect(loaded.first.sequence, original.sequence);
      expect(loaded.first.status, original.status);
    });
  });
}
