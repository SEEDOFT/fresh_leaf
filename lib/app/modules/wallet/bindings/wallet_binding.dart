import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WalletController>()) {
      Get.lazyPut<WalletController>(
        () => WalletController(apiClient: Get.find<ApiClient>()),
      );
    }
  }
}
