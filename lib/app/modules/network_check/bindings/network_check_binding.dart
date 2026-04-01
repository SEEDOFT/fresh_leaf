import 'package:fresh_leaf/app/modules/network_check/controllers/network_check_controller.dart';
import 'package:get/get.dart';

class NetworkCheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkCheckController>(NetworkCheckController.new);
  }
}
