import 'package:fresh_leaf/app/modules/profile/controllers/profile_addresses_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class ProfileAddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileAddressesController>(
      () => ProfileAddressesController(
        apiClient: Get.find<ApiClient>(),
        profileController: Get.find<ProfileController>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
