import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
    if (!Get.isRegistered<SearchController>()) {
      Get.lazyPut<SearchController>(() => SearchController());
    }
  }
}
