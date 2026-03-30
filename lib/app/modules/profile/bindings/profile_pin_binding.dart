import 'package:get/get.dart';
import '../controllers/profile_pin_controller.dart';

class ProfilePinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePinController>(() => ProfilePinController());
  }
}
