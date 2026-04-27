import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/modules/login/widgets/login_form_content_widget.dart';
import 'package:fresh_leaf/shared/widgets/organic_background_widget.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const OrganicBackgroundWidget(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LoginFormContent(
                    controller: controller,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
