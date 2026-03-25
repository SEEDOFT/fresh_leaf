import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();

  var currentPage = 0.obs;

  bool get isLastPage => currentPage.value == 2;

  void nextPage() {
    if (isLastPage) {
      Get.offNamed('/dashboard');
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
