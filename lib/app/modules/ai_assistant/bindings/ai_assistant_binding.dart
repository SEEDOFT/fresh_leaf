import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:get/get.dart';

class AiAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiAssistantController>(AiAssistantController.new);
  }
}
