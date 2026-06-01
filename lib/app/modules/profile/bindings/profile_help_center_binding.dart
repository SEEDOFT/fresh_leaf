import 'package:fresh_leaf/app/modules/profile/controllers/profile_help_center_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProfileHelpCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileHelpCenterController>(
      () => ProfileHelpCenterController(apiClient: Get.find<ApiClient>()),
    );
  }
}
