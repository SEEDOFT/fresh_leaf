import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/services/network_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  OnboardingController({required StorageService storageService})
    : _storageService = storageService;

  final StorageService _storageService;
  final pageController = PageController();
  RxInt currentPage = 0.obs;
  bool get isLastPage => currentPage.value == 2;

  Future<void> nextPage() async {
    if (isLastPage) {
      await _markSeen();
      await _goForward();
    } else {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> skip() async {
    await _markSeen();
    await _goForward();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await _markSeen();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> _markSeen() async {
    await _storageService.saveOnboardingSeen(seen: true);
  }

  Future<void> _goForward() async {
    final token = _storageService.token;
    if (token != null && token.isNotEmpty) {
      await Get.offAllNamed<void>(AppRoutes.dashboard);
    } else {
      final hasInternet = await NetworkService.hasInternetConnection();
      await Get.offAllNamed<void>(
        hasInternet ? AppRoutes.login : AppRoutes.networkCheck,
      );
    }
  }
}
