import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/login/widgets/login_widget.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const Scaffold(
        backgroundColor: Color(0xFFFDF6E3), // AppColors.backgroundCream
        body: SafeArea(
          child: Stack(
            children: [
              // 1. Background Hero Image & Logo
              BackgroundHeroWidget(),

              // 2. White Form Card (Overlapping)
              LoginFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
