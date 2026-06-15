import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/app/modules/wallet_top_up/controllers/wallet_top_up_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/payment_session_service.dart';
import 'package:get/get.dart';

class WalletTopUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletTopUpController>(
      () => WalletTopUpController(
        paymentSessionService: Get.find<PaymentSessionService>(),
        walletController: Get.find<WalletController>(),
        apiClient: Get.find<ApiClient>(),
      ),
    );
  }
}
