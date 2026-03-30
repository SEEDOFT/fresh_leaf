import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/controllers/ai_assistant_controller.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/app/modules/profile/controllers/profile_controller.dart';
import 'package:fresh_leaf/app/modules/search/controllers/search_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    _lazy(() => DashboardController());
    _lazy(() => HomeController());
    _lazy(() => CartController());
    _lazy(() => AiAssistantController());
    _lazy(() => OrdersController());
    _lazy(() => ProfileController());
    _lazy(() => SearchController());
  }

  void _lazy<T>(T Function() builder) {
    if (!Get.isRegistered<T>()) {
      Get.lazyPut<T>(builder);
    }
  }
}
