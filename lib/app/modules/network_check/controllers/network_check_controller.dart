import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/network_service.dart';
import 'package:get/get.dart';

class NetworkCheckController extends GetxController {
  final isChecking = false.obs;
  final isOnline = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnection();
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

  void continueToLogin() {
    if (!isOnline.value) {
      Get.snackbar(
        'no_internet_connection'.tr,
        'connect_internet_to_continue'.tr,
      );
      return;
    }
    Get.offAllNamed(AppRoutes.login);
  }
}
