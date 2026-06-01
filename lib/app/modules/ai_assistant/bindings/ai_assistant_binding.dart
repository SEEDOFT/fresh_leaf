import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/core/services/ai_assistant_api_service.dart';
import 'package:fresh_leaf/core/services/ai_assistant_realtime_service.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class AiAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<AiAssistantApiService>(
        () => AiAssistantApiService(apiClient: Get.find<ApiClient>()),
      )
      ..lazyPut<AiAssistantRealtimeService>(
        () => AiAssistantRealtimeService(apiClient: Get.find<ApiClient>()),
      )
      ..lazyPut<AiAssistantController>(
        () => AiAssistantController(
          aiChatStorageService: Get.find<AiChatStorageService>(),
          aiAssistantApiService: Get.find<AiAssistantApiService>(),
          aiAssistantRealtimeService: Get.find<AiAssistantRealtimeService>(),
        ),
      );
  }
}
