import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable for password visibility
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    Get.offAllNamed(AppRoutes.dashboard);
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
