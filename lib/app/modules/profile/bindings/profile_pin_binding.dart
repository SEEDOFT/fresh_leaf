import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class ProfilePinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePinController>(
      () => ProfilePinController(
        storageService: Get.find<StorageService>(),
        apiClient: Get.find<ApiClient>(),
      ),
    );
  }
}
