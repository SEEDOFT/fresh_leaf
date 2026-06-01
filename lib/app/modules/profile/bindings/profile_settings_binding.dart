import 'package:fresh_leaf/app/modules/profile/controllers/profile_settings_controller.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/services/ai_chat_storage_service.dart';
import 'package:get/get.dart';

class ProfileSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingsController>(
      () => ProfileSettingsController(
        appSettingsController: Get.find<AppSettingsController>(),
        aiChatStorageService: Get.find<AiChatStorageService>(),
      ),
    );
  }
}
