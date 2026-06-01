import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProfilePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePaymentController>(
      () => ProfilePaymentController(
        apiClient: Get.find<ApiClient>(),
        profileController: Get.find<ProfileController>(),
      ),
    );
  }
}
