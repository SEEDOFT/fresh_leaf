import 'package:fresh_leaf/app/modules/profile/controllers/profile_address_edit_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProfileAddressEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileAddressEditController>(
      () => ProfileAddressEditController(apiClient: Get.find<ApiClient>()),
    );
  }
}
