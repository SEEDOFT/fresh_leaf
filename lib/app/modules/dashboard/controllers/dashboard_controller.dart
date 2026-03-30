import 'package:fresh_leaf/app/modules/ai_assistant/views/ai_assistant_view.dart';
import 'package:fresh_leaf/app/modules/home/views/home_view.dart';
import 'package:fresh_leaf/app/modules/orders/views/orders_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_view.dart';
import 'package:fresh_leaf/app/modules/search/views/search_view.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    const HomeView(),
    const SearchView(),
    const AiAssistantView(),
    const OrdersView(),
    const ProfileView(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
