import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAiService {
  late final GenerativeModel _model;

  GeminiAiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in environment');
    }
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  }

  Future<String> generateContent(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No response from AI';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
