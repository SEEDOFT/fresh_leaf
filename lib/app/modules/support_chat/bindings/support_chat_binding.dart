import 'package:fresh_leaf/app/modules/support_chat/controllers/support_chat_controller.dart';
import 'package:get/get.dart';

class SupportChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportChatController>(SupportChatController.new);
  }
}
