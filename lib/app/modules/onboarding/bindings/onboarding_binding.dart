import 'package:fresh_leaf/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(storageService: Get.find<StorageService>()),
    );
  }
}
