import 'package:fresh_leaf/app/modules/profile/controllers/profile_security_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProfileSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSecurityController>(
      () => ProfileSecurityController(apiClient: Get.find<ApiClient>()),
    );
  }
}
