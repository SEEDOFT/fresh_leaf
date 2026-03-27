import 'package:fresh_leaf/app/modules/ai_assistant/views/ai_assistant_view.dart';
import 'package:fresh_leaf/app/modules/cart/views/cart_view.dart';
import 'package:fresh_leaf/app/modules/home/views/home_view.dart';
import 'package:fresh_leaf/app/modules/orders/views/orders_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_view.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    const HomeView(),
    const CartView(),
    const AiAssistantView(),
    const OrdersView(),
    const ProfileView(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
