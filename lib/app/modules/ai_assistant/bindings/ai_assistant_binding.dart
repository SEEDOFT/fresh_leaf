import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:get/get.dart';

class AiAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<AiAssistantApiService>(AiAssistantApiService.new)
      ..lazyPut<AiAssistantRealtimeService>(AiAssistantRealtimeService.new)
      ..lazyPut<AiAssistantController>(AiAssistantController.new);
  }
}
