import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:fresh_leaf/core/services/network_service.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();

  var currentPage = 0.obs;

  bool get isLastPage => currentPage.value == 2;

  void nextPage() async {
    if (isLastPage) {
      _markSeen();
      await _goForward();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() async {
    _markSeen();
    await _goForward();
  }

  @override
  void onInit() {
    super.onInit();
    // Mark onboarding as seen once the flow starts
    _markSeen();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _markSeen() {
    final storage = Get.find<StorageService>();
    storage.saveOnboardingSeen(true);
  }

  Future<void> _goForward() async {
    final storage = Get.find<StorageService>();
    final token = storage.token;
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      final hasInternet = await NetworkService.hasInternetConnection();
      Get.offAllNamed(hasInternet ? AppRoutes.login : AppRoutes.networkCheck);
    }
  }
}
