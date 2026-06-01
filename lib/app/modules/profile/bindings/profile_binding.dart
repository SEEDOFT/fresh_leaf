import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:fresh_leaf/core/controllers/app_settings_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
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
}
