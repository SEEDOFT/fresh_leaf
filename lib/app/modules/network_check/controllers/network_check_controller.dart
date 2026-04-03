import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/network_service.dart';
import 'package:get/get.dart';

class NetworkCheckController extends GetxController {
  final RxBool isChecking = false.obs;
  final RxBool isOnline = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkConnection();
  }

  Future<void> checkConnection() async {
    if (isChecking.value) return;
    isChecking.value = true;

    try {
      isOnline.value = await NetworkService.hasInternetConnection();
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> continueToLogin() async {
    if (!isOnline.value) {
      Get.snackbar(
        'no_internet_connection'.tr,
        'connect_internet_to_continue'.tr,
      );
      return;
    }
    await Get.offAllNamed<void>(AppRoutes.login);
  }
}
