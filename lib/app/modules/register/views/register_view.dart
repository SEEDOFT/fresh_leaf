import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/register/widgets/register_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundCream,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: Get.back,
          ),
        ),
        backgroundColor: AppColors.bgCream,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => RegisterFormContent(
              controller: controller,
              constraints: constraints,
            ),
          ),
        ),
      ),
    );
  }
}
