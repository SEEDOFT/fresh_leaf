import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WalletController>()) {
      Get.put(
        WalletController(apiClient: Get.find<ApiClient>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(
        () => ProfileController(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
          appSettingsController: Get.find<AppSettingsController>(),
          walletController: Get.find<WalletController>(),
          notificationService: Get.find<NotificationService>(),
        ),
      );
    }
    Get.lazyPut<LoginController>(
      () => LoginController(
        apiClient: Get.find<ApiClient>(),
        storageService: Get.find<StorageService>(),
        notificationService: Get.find<NotificationService>(),
        profileController: Get.find<ProfileController>(),
        appSettings: Get.find<AppSettingsController>(),
      ),
    );
  }
}
