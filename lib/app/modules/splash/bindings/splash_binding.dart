import 'package:fresh_leaf/app/modules/splash/controllers/splash_controller.dart';
import 'package:fresh_leaf/core/services/launch_route_service.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
        launchRouteService: Get.find<LaunchRouteService>(),
      ),
    );
  }
}
