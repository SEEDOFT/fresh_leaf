import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(
        apiClient: Get.find<ApiClient>(),
        storageService: Get.find<StorageService>(),
        notificationService: Get.find<NotificationService>(),
      ),
    );
  }
}
