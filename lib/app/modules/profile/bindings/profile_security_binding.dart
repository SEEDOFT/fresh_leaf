import 'package:get/get.dart';
import '../controllers/profile_security_controller.dart';

class ProfileSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSecurityController>(() => ProfileSecurityController());
  }
}
