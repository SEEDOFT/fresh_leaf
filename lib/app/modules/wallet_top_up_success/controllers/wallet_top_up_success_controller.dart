import 'package:get/get.dart';

class WalletTopUpSuccessController extends GetxController {
  final RxDouble topUpAmount = 0.0.obs;
  final RxString currency = 'USD'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      topUpAmount.value = args['amount'] as double? ?? 0.0;
      currency.value = args['currency'] as String? ?? 'USD';
    }
  }

  void done() {
    Get.back<void>();
  }
}
