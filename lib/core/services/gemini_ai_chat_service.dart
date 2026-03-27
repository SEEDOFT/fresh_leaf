import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fresh_leaf/core/config/app_config.dart';

class GeminiAiChatService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiAiChatService() {
    final apiKey = AppConfig.geminiApiKey;
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in environment');
    }
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? 'No response';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Stream<String> streamResponse(String prompt) async* {
    final content = [Content.text(prompt)];
    final stream = _model.generateContentStream(content);

    await for (final chunk in stream) {
      if (chunk.text != null) {
        yield chunk.text!;
      }
    }
  }
}
