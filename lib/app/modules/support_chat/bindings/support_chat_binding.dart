import 'package:fresh_leaf/app/modules/support_chat/controllers/support_chat_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/chat_realtime_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class SupportChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportChatController>(
      () => SupportChatController(
        apiClient: Get.find<ApiClient>(),
        storageService: Get.find<StorageService>(),
        realtimeService: Get.find<ChatRealtimeService>(),
      ),
    );
  }
}
