import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:get/get.dart';

class WalletTopUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletTopUpController>(WalletTopUpController.new);
  }
}
