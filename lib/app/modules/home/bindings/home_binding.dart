import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/core/repositories/home_repository.dart';
import 'package:fresh_leaf/core/repositories/location_repository.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/notification_service.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.find<ApiClient>();
    Get.lazyPut<HomeController>(
      () => HomeController(
        productService: Get.find<ProductService>(),
        notificationService: Get.find<NotificationService>(),
        homeRepository: HomeRepository(apiClient: apiClient),
        locationRepository: LocationRepository(apiClient: apiClient),
      ),
    );
  }
}
