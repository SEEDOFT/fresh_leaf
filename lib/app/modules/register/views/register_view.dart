import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/register/controllers/register_controller.dart';
import 'package:fresh_leaf/app/modules/register/widgets/register_form_content_widget.dart';
import 'package:fresh_leaf/shared/widgets/organic_background_widget.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
                  padding: const EdgeInsets.all(24),
                  child: RegisterFormContent(
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
