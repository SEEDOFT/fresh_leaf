import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_add_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class ProfilePaymentAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePaymentAddController>(
      () => ProfilePaymentAddController(apiClient: Get.find<ApiClient>()),
    );
  }
}
