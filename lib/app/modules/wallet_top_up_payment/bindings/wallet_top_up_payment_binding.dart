import 'package:fresh_leaf/app/modules/wallet_top_up_payment/controllers/wallet_top_up_payment_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class WalletTopUpPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletTopUpPaymentController>(
      () => WalletTopUpPaymentController(apiClient: Get.find<ApiClient>()),
    );
  }
}
