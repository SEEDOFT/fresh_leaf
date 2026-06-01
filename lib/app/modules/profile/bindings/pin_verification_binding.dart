import 'package:fresh_leaf/app/modules/profile/controllers/pin_verification_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class PinVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinVerificationController>(
      () => PinVerificationController(apiClient: Get.find<ApiClient>()),
    );
  }
}
