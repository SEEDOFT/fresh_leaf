import 'package:fresh_leaf/app/modules/wallet_top_up_success/controllers/wallet_top_up_success_controller.dart';
import 'package:get/get.dart';

class WalletTopUpSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletTopUpSuccessController>(WalletTopUpSuccessController.new);
  }
}
