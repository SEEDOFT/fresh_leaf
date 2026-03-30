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
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: LoginFormContent(
                    controller: controller,
                    constraints: constraints,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
