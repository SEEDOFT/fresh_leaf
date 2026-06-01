import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/app/modules/search/controllers/search_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(
      () => SearchController(homeController: Get.find<HomeController>()),
    );
  }
}
