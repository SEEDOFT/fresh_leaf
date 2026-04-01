import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/ai_assistant/views/ai_assistant_view.dart';
import 'package:fresh_leaf/app/modules/home/views/home_view.dart';
import 'package:fresh_leaf/app/modules/orders/views/orders_view.dart';
import 'package:fresh_leaf/app/modules/profile/views/profile_view.dart';
import 'package:fresh_leaf/app/modules/search/views/search_view.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;
  set currentIndex(int index) => _currentIndex.value = index;

  final List<StatelessWidget> pages = [
    const HomeView(),
    const SearchView(),
    const AiAssistantView(),
    const OrdersView(),
    const ProfileView(),
  ];
}
