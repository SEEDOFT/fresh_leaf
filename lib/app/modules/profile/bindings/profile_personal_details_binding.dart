import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_personal_details_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class ProfilePersonalDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePersonalDetailsController>(
      () => ProfilePersonalDetailsController(
        apiClient: Get.find<ApiClient>(),
        storageService: Get.find<StorageService>(),
        profileController: Get.find<ProfileController>(),
      ),
    );
  }
}
